import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../shared/constants/report_constants.dart';
import '../../shared/utils/firebase_error_helper.dart';
import '../../../Features/user/data/models/report_model.dart';
import '../../../Features/user/domain/entities/report_entity.dart';

class ReportFirestoreDatasource {
  static const Duration _operationTimeout = Duration(seconds: 25);
  static const Duration _availabilityTimeout = Duration(seconds: 8);

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ReportFirestoreDatasource({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection(ReportConstants.firestoreCollection);

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action().timeout(_operationTimeout);
    } on TimeoutException {
      throw const ReportServiceException(FirebaseErrorHelper.timeoutMessage);
    } on FirebaseException catch (e) {
      FirebaseErrorHelper.rethrowAsReportException(e);
    } catch (e) {
      FirebaseErrorHelper.rethrowAsReportException(e);
    }
  }

  Future<String?> uploadReportImage({
    required String reportId,
    required String localPath,
  }) async {
    try {
      final file = File(localPath);
      if (!await file.exists()) return null;

      final extension = localPath.split('.').last;
      final ref = _storage.ref().child(
        '${ReportConstants.storageFolder}/$reportId/image.$extension',
      );
      await ref.putFile(file).timeout(_operationTimeout);
      return await ref.getDownloadURL().timeout(_operationTimeout);
    } catch (_) {
      return null;
    }
  }

  Future<void> deleteReportImage(String? imageUrl) async {
    if (imageUrl == null || imageUrl.isEmpty) return;
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete().timeout(_operationTimeout);
    } catch (_) {}
  }

  Future<ReportModel> createReport(ReportModel report) async {
    return _guard(() async {
      await _collection.doc(report.id).set(report.toFirestore());
      return report;
    });
  }

  Future<bool> isAvailable() async {
    try {
      await _collection.limit(1).get().timeout(_availabilityTimeout);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<ReportModel>> getAllReports() async {
    return _guard(() async {
      final snapshot = await _collection
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => ReportModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<List<ReportModel>> getUserReports(String userId) async {
    return _guard(() async {
      final snapshot = await _collection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs
          .map((doc) => ReportModel.fromFirestore(doc))
          .toList();
    });
  }

  Stream<List<ReportModel>> watchUserReports(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReportModel.fromFirestore(doc))
              .toList(),
        )
        .handleError((Object error) {
          throw ReportServiceException(
            FirebaseErrorHelper.toUserMessage(error),
          );
        });
  }

  Stream<List<ReportModel>> watchAllReports() {
    return _collection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReportModel.fromFirestore(doc))
              .toList(),
        )
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
            ? Timestamp.fromDate(entry.value as DateTime)
            : entry.value;
      }
      processed['updatedAt'] = Timestamp.fromDate(DateTime.now());
      await _collection.doc(reportId).update(processed);
    });
  }

  Future<ReportModel?> getReportById(String reportId) async {
    return _guard(() async {
      final snapshot = await _collection.doc(reportId).get();
      if (!snapshot.exists) return null;
      return ReportModel.fromFirestore(snapshot);
    });
  }

  Future<void> deleteReportDocument(String reportId) async {
    await _guard(() => _collection.doc(reportId).delete());
  }

  Future<List<ReportModel>> getExpiredResolvedReports() async {
    try {
      final now = Timestamp.fromDate(DateTime.now());
      final snapshot = await _collection
          .where('status', isEqualTo: ReportStatus.resolved.name)
          .where('scheduledDeleteAt', isLessThanOrEqualTo: now)
          .get()
          .timeout(_operationTimeout);
      return snapshot.docs
          .map((doc) => ReportModel.fromFirestore(doc))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
