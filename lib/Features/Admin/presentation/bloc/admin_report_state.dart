part of 'admin_report_bloc.dart';

abstract class AdminReportState extends Equatable {
  const AdminReportState();

  @override
  List<Object?> get props => [];
}

class AdminReportInitial extends AdminReportState {
  const AdminReportInitial();
}

class AdminReportLoading extends AdminReportState {
  const AdminReportLoading();
}

class AdminReportLoaded extends AdminReportState {
  final List<ReportEntity> reports;
  final List<ReportEntity> allReports;
  final ReportStatus? filterStatus;

  const AdminReportLoaded({
    required this.reports,
    required this.allReports,
    this.filterStatus,
  });

  int get pendingCount =>
      allReports.where((r) => r.status == ReportStatus.pending).length;

  int get inProgressCount =>
      allReports.where((r) => r.status == ReportStatus.inProgress).length;

  int get resolvedCount =>
      allReports.where((r) => r.status == ReportStatus.resolved).length;

  @override
  List<Object?> get props => [reports, allReports, filterStatus];
}

class AdminReportError extends AdminReportState {
  final String message;

  const AdminReportError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AdminReportActionInProgress extends AdminReportState {
  final String reportId;

  const AdminReportActionInProgress({required this.reportId});

  @override
  List<Object?> get props => [reportId];
}

class AdminReportActionSuccess extends AdminReportState {
  final String message;

  const AdminReportActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AdminReportActionFailure extends AdminReportState {
  final String message;

  const AdminReportActionFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
