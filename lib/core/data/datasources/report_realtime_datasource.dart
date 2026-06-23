import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import '../../shared/constants/report_constants.dart';
import '../../shared/utils/firebase_error_helper.dart';
import '../../../Features/user/data/models/report_model.dart';
import '../../../Features/user/domain/entities/report_entity.dart';

class ReportRealtimeDatasource {
  static const Duration _operationTimeout = Duration(seconds: 20);

  final DatabaseReference _reportsRef;

  ReportRealtimeDatasource({DatabaseReference? reportsRef})
    : _reportsRef =
          reportsRef ??
          FirebaseDatabase.instance.ref(ReportConstants.rtdbReportsPath);

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action().timeout(_operationTimeout);
    } on TimeoutException {
      throw const ReportServiceException(FirebaseErrorHelper.timeoutMessage);
    } catch (e) {
      FirebaseErrorHelper.rethrowAsReportException(e);
    }
  }

  Future<ReportModel> createReport(ReportModel report) async {
    return _guard(() async {
      await _reportsRef.child(report.id).set(report.toJson());
      return report;
    });
  }

  Future<List<ReportModel>> getAllReports() async {
    return _guard(() async {
      final snapshot = await _reportsRef.get();
      return _parseSnapshot(snapshot);
    });
  }

  Future<List<ReportModel>> getUserReports(String userId) async {
    final all = await getAllReports();
    return all.where((r) => r.userId == userId).toList();
  }

  Stream<List<ReportModel>> watchUserReports(String userId) {
    return watchAllReports().map(
      (reports) => reports.where((r) => r.userId == userId).toList(),
    );
  }

  Stream<List<ReportModel>> watchAllReports() {
    return _reportsRef.onValue
        .map((event) {
          return _parseSnapshot(event.snapshot);
        })
        .handleError((Object error) {
          throw ReportServiceException(
            FirebaseErrorHelper.toUserMessage(error),
          );
        });
  }

  Future<void> updateReportFields(
    String reportId,
    Map<String, dynamic> fields,
  ) async {
    await _guard(() async {
      final processed = <String, dynamic>{};
      for (final entry in fields.entries) {
        processed[entry.key] = entry.value is DateTime
            ? (entry.value as DateTime).toIso8601String()
            : entry.value;
      }
      processed['updatedAt'] = DateTime.now().toIso8601String();
      await _reportsRef.child(reportId).update(processed);
    });
  }

  Future<ReportModel?> getReportById(String reportId) async {
    return _guard(() async {
      final snapshot = await _reportsRef.child(reportId).get();
      if (!snapshot.exists || snapshot.value is! Map) return null;
      return ReportModel.fromMap(
        Map<String, dynamic>.from(snapshot.value as Map),
        id: reportId,
      );
    });
  }

  Future<void> deleteReportDocument(String reportId) async {
    await _guard(() => _reportsRef.child(reportId).remove());
  }

  Future<List<ReportModel>> getExpiredResolvedReports() async {
    try {
      final all = await getAllReports();
      return all.where((r) => r.isExpiredForDeletion).toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> isAvailable() async {
    try {
      await _reportsRef
          .child('_connectivity_ping')
          .get()
          .timeout(const Duration(seconds: 8));
      return true;
    } catch (_) {
      return false;
    }
  }

  List<ReportModel> _parseSnapshot(DataSnapshot snapshot) {
    final value = snapshot.value;
    if (value is! Map) return [];

    final reports = <ReportModel>[];
    value.forEach((key, raw) {
      if (key is String && key.startsWith('_')) return;
      if (key is String && raw is Map) {
        reports.add(
          ReportModel.fromMap(Map<String, dynamic>.from(raw), id: key),
        );
      }
    });

    reports.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return reports;
  }
}
