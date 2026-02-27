import 'package:equatable/equatable.dart';

/// Represents the severity level of a report
enum ReportSeverity {
  low,
  medium,
  high,
}

/// Represents the status of a submitted report
enum ReportStatus {
  pending,
  inProgress,
  resolved,
  rejected,
}

extension ReportSeverityExtension on ReportSeverity {
  String get displayName {
    switch (this) {
      case ReportSeverity.low:
        return 'منخفضة';
      case ReportSeverity.medium:
        return 'متوسطة';
      case ReportSeverity.high:
        return 'عالية';
    }
  }
}

extension ReportStatusExtension on ReportStatus {
  String get displayName {
    switch (this) {
      case ReportStatus.pending:
        return 'قيد المراجعة';
      case ReportStatus.inProgress:
        return 'قيد المعالجة';
      case ReportStatus.resolved:
        return 'تم الحل';
      case ReportStatus.rejected:
        return 'مرفوض';
    }
  }
}

class ReportEntity extends Equatable {
  final String id;
  final String issueType;
  final String description;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? imagePath;
  final ReportSeverity severity;
  final ReportStatus status;
  final DateTime createdAt;

  const ReportEntity({
    required this.id,
    required this.issueType,
    required this.description,
    this.latitude,
    this.longitude,
    this.address,
    this.imagePath,
    required this.severity,
    this.status = ReportStatus.pending,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        issueType,
        description,
        latitude,
        longitude,
        address,
        imagePath,
        severity,
        status,
        createdAt,
      ];
}
