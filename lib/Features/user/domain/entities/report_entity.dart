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
  final String? imageUrl;
  final ReportSeverity severity;
  final ReportStatus status;
  final DateTime createdAt;
  final String userId;
  final String userName;
  final String? workerId;
  final String? workerName;
  final String? workerResponse;
  final String? adminNote;
  final DateTime? resolvedAt;
  final DateTime? scheduledDeleteAt;
  final DateTime? updatedAt;

  const ReportEntity({
    required this.id,
    required this.issueType,
    required this.description,
    this.latitude,
    this.longitude,
    this.address,
    this.imagePath,
    this.imageUrl,
    required this.severity,
    this.status = ReportStatus.pending,
    required this.createdAt,
    required this.userId,
    required this.userName,
    this.workerId,
    this.workerName,
    this.workerResponse,
    this.adminNote,
    this.resolvedAt,
    this.scheduledDeleteAt,
    this.updatedAt,
  });

  bool get isResolved => status == ReportStatus.resolved;

  bool get isExpiredForDeletion {
    if (scheduledDeleteAt == null) return false;
    return DateTime.now().isAfter(scheduledDeleteAt!);
  }

  Duration? get timeUntilDeletion {
    if (scheduledDeleteAt == null) return null;
    final remaining = scheduledDeleteAt!.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  ReportEntity copyWith({
    String? id,
    String? issueType,
    String? description,
    double? latitude,
    double? longitude,
    String? address,
    String? imagePath,
    String? imageUrl,
    ReportSeverity? severity,
    ReportStatus? status,
    DateTime? createdAt,
    String? userId,
    String? userName,
    String? workerId,
    String? workerName,
    String? workerResponse,
    String? adminNote,
    DateTime? resolvedAt,
    DateTime? scheduledDeleteAt,
    DateTime? updatedAt,
  }) {
    return ReportEntity(
      id: id ?? this.id,
      issueType: issueType ?? this.issueType,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      imagePath: imagePath ?? this.imagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      workerId: workerId ?? this.workerId,
      workerName: workerName ?? this.workerName,
      workerResponse: workerResponse ?? this.workerResponse,
      adminNote: adminNote ?? this.adminNote,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      scheduledDeleteAt: scheduledDeleteAt ?? this.scheduledDeleteAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        issueType,
        description,
        latitude,
        longitude,
        address,
        imagePath,
        imageUrl,
        severity,
        status,
        createdAt,
        userId,
        userName,
        workerId,
        workerName,
        workerResponse,
        adminNote,
        resolvedAt,
        scheduledDeleteAt,
        updatedAt,
      ];
}
