import 'package:cloud_firestore/cloud_firestore.dart';
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
    super.imageUrl,
    required super.severity,
    super.status = ReportStatus.pending,
    required super.createdAt,
    required super.userId,
    required super.userName,
    super.workerId,
    super.workerName,
    super.workerResponse,
    super.adminNote,
    super.resolvedAt,
    super.scheduledDeleteAt,
    super.updatedAt,
  });

  factory ReportModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ReportModel.fromMap(data, id: doc.id);
  }

  factory ReportModel.fromMap(Map<String, dynamic> data, {String? id}) {
    return ReportModel(
      id: id ?? data['id'] as String? ?? '',
      issueType: data['issueType'] as String? ?? '',
      description: data['description'] as String? ?? '',
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      address: data['address'] as String?,
      imagePath: data['imagePath'] as String?,
      imageUrl: data['imageUrl'] as String?,
      severity: ReportSeverity.values.firstWhere(
        (e) => e.name == data['severity'],
        orElse: () => ReportSeverity.medium,
      ),
      status: ReportStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => ReportStatus.pending,
      ),
      createdAt: _parseDateTime(data['createdAt']) ?? DateTime.now(),
      userId: data['userId'] as String? ?? '',
      userName: data['userName'] as String? ?? 'مستخدم',
      workerId: data['workerId'] as String?,
      workerName: data['workerName'] as String?,
      workerResponse: data['workerResponse'] as String?,
      adminNote: data['adminNote'] as String?,
      resolvedAt: _parseDateTime(data['resolvedAt']),
      scheduledDeleteAt: _parseDateTime(data['scheduledDeleteAt']),
      updatedAt: _parseDateTime(data['updatedAt']),
    );
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel.fromMap(json);
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'issueType': issueType,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'imagePath': imagePath,
      'imageUrl': imageUrl,
      'severity': severity.name,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'userId': userId,
      'userName': userName,
      'workerId': workerId,
      'workerName': workerName,
      'workerResponse': workerResponse,
      'adminNote': adminNote,
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      'scheduledDeleteAt': scheduledDeleteAt != null
          ? Timestamp.fromDate(scheduledDeleteAt!)
          : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
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
      'imageUrl': imageUrl,
      'severity': severity.name,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
      'userName': userName,
      'workerId': workerId,
      'workerName': workerName,
      'workerResponse': workerResponse,
      'adminNote': adminNote,
      'resolvedAt': resolvedAt?.toIso8601String(),
      'scheduledDeleteAt': scheduledDeleteAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
