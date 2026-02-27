import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../models/report_model.dart';

const _reportsKey = 'user_reports_history';

class ReportRepositoryImpl implements ReportRepository {
  final SharedPreferences _sharedPreferences;

  ReportRepositoryImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  @override
  Future<ReportEntity> submitReport(ReportEntity report) async {
    final reports = await getReportsHistory();
    final reportModel = ReportModel(
      id: report.id,
      issueType: report.issueType,
      description: report.description,
      latitude: report.latitude,
      longitude: report.longitude,
      address: report.address,
      imagePath: report.imagePath,
      severity: report.severity,
      status: report.status,
      createdAt: report.createdAt,
    );
    reports.insert(0, reportModel);
    await _saveReports(reports);
    return reportModel;
  }

  @override
  Future<List<ReportEntity>> getReportsHistory() async {
    final jsonString = _sharedPreferences.getString(_reportsKey);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((e) => ReportModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveReports(List<ReportEntity> reports) async {
    final jsonList = reports
        .map((r) => _toJson(r))
        .toList();
    await _sharedPreferences.setString(_reportsKey, jsonEncode(jsonList));
  }

  Map<String, dynamic> _toJson(ReportEntity r) {
    if (r is ReportModel) return r.toJson();
    return ReportModel(
      id: r.id,
      issueType: r.issueType,
      description: r.description,
      latitude: r.latitude,
      longitude: r.longitude,
      address: r.address,
      imagePath: r.imagePath,
      severity: r.severity,
      status: r.status,
      createdAt: r.createdAt,
    ).toJson();
  }
}
