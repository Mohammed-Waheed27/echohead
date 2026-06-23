part of 'admin_report_bloc.dart';

abstract class AdminReportEvent extends Equatable {
  const AdminReportEvent();

  @override
  List<Object?> get props => [];
}

class AdminWatchReportsEvent extends AdminReportEvent {
  const AdminWatchReportsEvent();
}

class AdminFilterReportsEvent extends AdminReportEvent {
  final ReportStatus? status;

  const AdminFilterReportsEvent({this.status});

  @override
  List<Object?> get props => [status];
}

class AdminUpdateReportEvent extends AdminReportEvent {
  final String reportId;
  final ReportStatus status;
  final String? adminNote;

  const AdminUpdateReportEvent({
    required this.reportId,
    required this.status,
    this.adminNote,
  });

  @override
  List<Object?> get props => [reportId, status, adminNote];
}

class AdminDeleteReportEvent extends AdminReportEvent {
  final String reportId;

  const AdminDeleteReportEvent({required this.reportId});

  @override
  List<Object?> get props => [reportId];
}
