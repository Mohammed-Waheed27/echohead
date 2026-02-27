import '../entities/report_entity.dart';

abstract class ReportRepository {
  /// Submits a new report
  Future<ReportEntity> submitReport(ReportEntity report);

  /// Retrieves all submitted reports (history)
  Future<List<ReportEntity>> getReportsHistory();
}
