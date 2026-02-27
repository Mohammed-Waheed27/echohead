part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class SubmitReportEvent extends ReportEvent {
  final String issueType;
  final String description;
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? imagePath;
  final ReportSeverity severity;

  const SubmitReportEvent({
    required this.issueType,
    required this.description,
    this.latitude,
    this.longitude,
    this.address,
    this.imagePath,
    required this.severity,
  });

  @override
  List<Object?> get props => [issueType, description, latitude, longitude, address, imagePath, severity];
}

class LoadReportsHistoryEvent extends ReportEvent {
  const LoadReportsHistoryEvent();
}
