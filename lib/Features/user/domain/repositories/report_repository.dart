import '../entities/report_entity.dart';

abstract class ReportRepository {
  /// Submits a new report to Firestore.
  Future<ReportEntity> submitReport(ReportEntity report);

  /// Retrieves reports for a specific user.
  Future<List<ReportEntity>> getReportsHistory({required String userId});

  /// Real-time stream of user reports for status tracking.
  Stream<List<ReportEntity>> watchUserReports(String userId);

  /// Real-time stream of all active reports (admin/worker).
  Stream<List<ReportEntity>> watchAllReports();

  /// One-time fetch of all reports (with timeout — used for initial load).
  Future<List<ReportEntity>> getAllReports();

  /// Updates report status and optional notes/response.
  Future<void> updateReport({
    required String reportId,
    ReportStatus? status,
    String? adminNote,
    String? workerResponse,
    String? workerId,
    String? workerName,
  });

  /// Marks a report as resolved and schedules auto-deletion.
  Future<void> markAsResolved({
    required String reportId,
    required String workerId,
    required String workerName,
    String? workerResponse,
  });

  /// Deletes a report directly (worker/admin).
  Future<void> deleteReport(String reportId);

  /// Removes resolved reports past their scheduled deletion time.
  Future<void> purgeExpiredResolvedReports();

  /// Returns or creates a persistent guest user id for anonymous reporters.
  Future<String> getOrCreateGuestUserId();
}
