part of 'worker_report_bloc.dart';

abstract class WorkerReportEvent extends Equatable {
  const WorkerReportEvent();

  @override
  List<Object?> get props => [];
}

class WorkerWatchReportsEvent extends WorkerReportEvent {
  const WorkerWatchReportsEvent();
}

class WorkerFilterReportsEvent extends WorkerReportEvent {
  final ReportStatus? status;

  const WorkerFilterReportsEvent({this.status});

  @override
  List<Object?> get props => [status];
}

class WorkerTakeReportEvent extends WorkerReportEvent {
  final String reportId;

  const WorkerTakeReportEvent({required this.reportId});

  @override
  List<Object?> get props => [reportId];
}

class WorkerRespondReportEvent extends WorkerReportEvent {
  final String reportId;
  final String response;

  const WorkerRespondReportEvent({
    required this.reportId,
    required this.response,
  });

  @override
  List<Object?> get props => [reportId, response];
}

class WorkerResolveReportEvent extends WorkerReportEvent {
  final String reportId;
  final String? response;

  const WorkerResolveReportEvent({required this.reportId, this.response});

  @override
  List<Object?> get props => [reportId, response];
}

class WorkerDeleteReportEvent extends WorkerReportEvent {
  final String reportId;

  const WorkerDeleteReportEvent({required this.reportId});

  @override
  List<Object?> get props => [reportId];
}
