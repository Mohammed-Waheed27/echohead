import 'package:equatable/equatable.dart';

enum WorkerJobType {
  cleaning,
  fixing,
}

enum WorkerJobStatus {
  pending,
  inProgress,
  done,
}

class WorkerJobEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final WorkerJobType type;
  final WorkerJobStatus status;
  final double latitude;
  final double longitude;
  final String? address;

  const WorkerJobEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.address,
  });

  WorkerJobEntity copyWith({
    String? id,
    String? title,
    String? description,
    WorkerJobType? type,
    WorkerJobStatus? status,
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return WorkerJobEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [id, title, description, type, status, latitude, longitude, address];
}
