import '../../domain/entities/report_entity.dart';

class ReportModel extends ReportEntity {
  const ReportModel({
    required super.id,
    required super.issueType,
    required super.description,
    super.latitude,
    super.longitude,
    super.address,
    super.imagePath,
    required super.severity,
    super.status = ReportStatus.pending,
    required super.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      issueType: json['issueType'] as String,
      description: json['description'] as String,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      address: json['address'] as String?,
      imagePath: json['imagePath'] as String?,
      severity: ReportSeverity.values.firstWhere(
        (e) => e.name == json['severity'],
        orElse: () => ReportSeverity.medium,
      ),
      status: ReportStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ReportStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'issueType': issueType,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'imagePath': imagePath,
      'severity': severity.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
