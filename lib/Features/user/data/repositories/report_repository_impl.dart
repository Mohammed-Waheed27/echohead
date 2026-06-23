import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/data/datasources/report_firestore_datasource.dart';
import '../../../../core/data/datasources/report_realtime_datasource.dart';
import '../../../../core/shared/constants/report_constants.dart';
import '../../../../core/shared/utils/firebase_error_helper.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../models/report_model.dart';

enum _ReportBackend { firestore, rtdb }

class ReportRepositoryImpl implements ReportRepository {
  final ReportFirestoreDatasource _firestore;
  final ReportRealtimeDatasource _rtdb;
  final SharedPreferences _sharedPreferences;

  _ReportBackend? _resolvedBackend;

  ReportRepositoryImpl({
    required ReportFirestoreDatasource firestoreDatasource,
    required ReportRealtimeDatasource rtdbDatasource,
    required SharedPreferences sharedPreferences,
  }) : _firestore = firestoreDatasource,
       _rtdb = rtdbDatasource,
       _sharedPreferences = sharedPreferences;

  Future<_ReportBackend> _resolveBackend({bool forceRecheck = false}) async {
    if (!forceRecheck && _resolvedBackend != null) {
      return _resolvedBackend!;
    }

    if (!forceRecheck) {
      final cached = _sharedPreferences.getString(
        ReportConstants.backendPreferenceKey,
      );
      if (cached == 'rtdb' && await _rtdb.isAvailable()) {
        _resolvedBackend = _ReportBackend.rtdb;
        return _resolvedBackend!;
      }
      if (cached == 'firestore' && await _firestore.isAvailable()) {
        _resolvedBackend = _ReportBackend.firestore;
        return _resolvedBackend!;
      }
    }

    // RTDB is already active in this project (smart bins) — try it first.
    if (await _rtdb.isAvailable()) {
      await _cacheBackend('rtdb');
      _resolvedBackend = _ReportBackend.rtdb;
      return _resolvedBackend!;
    }

    if (await _firestore.isAvailable()) {
      await _cacheBackend('firestore');
      _resolvedBackend = _ReportBackend.firestore;
      return _resolvedBackend!;
    }

    throw const ReportServiceException(
      'تعذر الاتصال بقاعدة البيانات.\n'
      'تحقق من الإنترنت، أو فعّل Cloud Firestore من Firebase Console، ثم أعد المحاولة.',
    );
  }

  Future<void> _cacheBackend(String value) async {
    await _sharedPreferences.setString(
      ReportConstants.backendPreferenceKey,
      value,
    );
  }

  Future<T> _withBackend<T>(
    Future<T> Function(_ReportBackend backend) action, {
    bool allowFallback = true,
  }) async {
    final backend = await _resolveBackend();
    try {
      return await action(backend);
    } catch (e) {
      if (!allowFallback) rethrow;

      final fallback = backend == _ReportBackend.firestore
          ? _ReportBackend.rtdb
          : _ReportBackend.firestore;

      final fallbackAvailable = fallback == _ReportBackend.firestore
          ? await _firestore.isAvailable()
          : await _rtdb.isAvailable();

      if (!fallbackAvailable) {
        FirebaseErrorHelper.rethrowAsReportException(e);
      }

      _resolvedBackend = fallback;
      await _cacheBackend(
        fallback == _ReportBackend.firestore ? 'firestore' : 'rtdb',
      );
      return action(fallback);
    }
  }

  @override
  Future<ReportEntity> submitReport(ReportEntity report) async {
    String? imageUrl;
    if (report.imagePath != null && report.imagePath!.isNotEmpty) {
      imageUrl = await _firestore.uploadReportImage(
        reportId: report.id,
        localPath: report.imagePath!,
      );
    }

    final reportModel = ReportModel(
      id: report.id,
      issueType: report.issueType,
      description: report.description,
      latitude: report.latitude,
      longitude: report.longitude,
      address: report.address,
      imagePath: report.imagePath,
      imageUrl: imageUrl,
      severity: report.severity,
      status: report.status,
      createdAt: report.createdAt,
      userId: report.userId,
      userName: report.userName,
      updatedAt: DateTime.now(),
    );

    return _withBackend((backend) async {
      if (backend == _ReportBackend.firestore) {
        return _firestore.createReport(reportModel);
      }
      return _rtdb.createReport(reportModel);
    });
  }

  @override
  Future<List<ReportEntity>> getAllReports() async {
    return _withBackend((backend) async {
      await _safePurgeExpired(backend);
      final reports = backend == _ReportBackend.firestore
          ? await _firestore.getAllReports()
          : await _rtdb.getAllReports();
      return _filterVisibleReports(reports);
    });
  }

  @override
  Future<List<ReportEntity>> getReportsHistory({required String userId}) async {
    return _withBackend((backend) async {
      await _safePurgeExpired(backend);
      final reports = backend == _ReportBackend.firestore
          ? await _firestore.getUserReports(userId)
          : await _rtdb.getUserReports(userId);
      return _filterVisibleReports(reports);
    });
  }

  @override
  Stream<List<ReportEntity>> watchUserReports(String userId) async* {
    final backend = await _resolveBackend();
    final stream = backend == _ReportBackend.firestore
        ? _firestore.watchUserReports(userId)
        : _rtdb.watchUserReports(userId);
    yield* stream.map(_filterVisibleReports);
  }

  @override
  Stream<List<ReportEntity>> watchAllReports() async* {
    final backend = await _resolveBackend();
    final stream = backend == _ReportBackend.firestore
        ? _firestore.watchAllReports()
        : _rtdb.watchAllReports();
    yield* stream.map(_filterVisibleReports);
  }

  @override
  Future<void> updateReport({
    required String reportId,
    ReportStatus? status,
    String? adminNote,
    String? workerResponse,
    String? workerId,
    String? workerName,
  }) async {
    final fields = <String, dynamic>{};
    if (status != null) fields['status'] = status.name;
    if (adminNote != null) fields['adminNote'] = adminNote;
    if (workerResponse != null) fields['workerResponse'] = workerResponse;
    if (workerId != null) fields['workerId'] = workerId;
    if (workerName != null) fields['workerName'] = workerName;

    if (status == ReportStatus.resolved) {
      final now = DateTime.now();
      fields['resolvedAt'] = now;
      fields['scheduledDeleteAt'] = now.add(
        const Duration(minutes: ReportConstants.resolvedRetentionMinutes),
      );
    }

    await _withBackend((backend) async {
      if (backend == _ReportBackend.firestore) {
        await _firestore.updateReportFields(reportId, fields);
      } else {
        await _rtdb.updateReportFields(reportId, fields);
      }
    }, allowFallback: false);
  }

  @override
  Future<void> markAsResolved({
    required String reportId,
    required String workerId,
    required String workerName,
    String? workerResponse,
  }) async {
    await updateReport(
      reportId: reportId,
      status: ReportStatus.resolved,
      workerId: workerId,
      workerName: workerName,
      workerResponse: workerResponse,
    );
  }

  @override
  Future<void> deleteReport(String reportId) async {
    await _withBackend((backend) async {
      ReportModel? report;
      if (backend == _ReportBackend.firestore) {
        report = await _firestore.getReportById(reportId);
      } else {
        report = await _rtdb.getReportById(reportId);
      }
      if (report != null) {
        await _firestore.deleteReportImage(report.imageUrl);
      }
      if (backend == _ReportBackend.firestore) {
        await _firestore.deleteReportDocument(reportId);
      } else {
        await _rtdb.deleteReportDocument(reportId);
      }
    }, allowFallback: false);
  }

  @override
  Future<void> purgeExpiredResolvedReports() async {
    final backend = await _resolveBackend();
    await _safePurgeExpired(backend);
  }

  Future<void> _safePurgeExpired(_ReportBackend backend) async {
    try {
      final expired = backend == _ReportBackend.firestore
          ? await _firestore.getExpiredResolvedReports()
          : await _rtdb.getExpiredResolvedReports();
      for (final report in expired) {
        await _firestore.deleteReportImage(report.imageUrl);
        if (backend == _ReportBackend.firestore) {
          await _firestore.deleteReportDocument(report.id);
        } else {
          await _rtdb.deleteReportDocument(report.id);
        }
      }
    } catch (_) {}
  }

  @override
  Future<String> getOrCreateGuestUserId() async {
    final existing = _sharedPreferences.getString(
      ReportConstants.guestUserIdKey,
    );
    if (existing != null && existing.isNotEmpty) return existing;

    final guestId = 'guest_${DateTime.now().millisecondsSinceEpoch}';
    await _sharedPreferences.setString(ReportConstants.guestUserIdKey, guestId);
    return guestId;
  }

  List<ReportEntity> _filterVisibleReports(List<ReportModel> reports) {
    return reports.where((report) => !report.isExpiredForDeletion).toList();
  }
}
