part of 'worker_report_bloc.dart';

abstract class WorkerReportState extends Equatable {
  const WorkerReportState();

  @override
  List<Object?> get props => [];
}

class WorkerReportInitial extends WorkerReportState {
  const WorkerReportInitial();
}

class WorkerReportLoading extends WorkerReportState {
  const WorkerReportLoading();
}

class WorkerReportLoaded extends WorkerReportState {
  final List<ReportEntity> reports;
  final List<ReportEntity> allReports;
  final ReportStatus? filterStatus;

  const WorkerReportLoaded({
    required this.reports,
    required this.allReports,
    this.filterStatus,
  });

  int get pendingCount =>
      allReports.where((r) => r.status == ReportStatus.pending).length;

  int get inProgressCount =>
      allReports.where((r) => r.status == ReportStatus.inProgress).length;

  @override
  List<Object?> get props => [reports, allReports, filterStatus];
}

class WorkerReportError extends WorkerReportState {
  final String message;

  const WorkerReportError({required this.message});

  @override
  List<Object?> get props => [message];
}

class WorkerReportActionInProgress extends WorkerReportState {
  final String reportId;

  const WorkerReportActionInProgress({required this.reportId});

  @override
  List<Object?> get props => [reportId];
}

class WorkerReportActionSuccess extends WorkerReportState {
  final String message;

  const WorkerReportActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class WorkerReportActionFailure extends WorkerReportState {
  final String message;

  const WorkerReportActionFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
