part of 'worker_job_bloc.dart';

abstract class WorkerJobEvent extends Equatable {
  const WorkerJobEvent();

  @override
  List<Object?> get props => [];
}

class WorkerJobLoadRequested extends WorkerJobEvent {
  const WorkerJobLoadRequested();
}

class WorkerJobMarkDoneRequested extends WorkerJobEvent {
  final String jobId;

  const WorkerJobMarkDoneRequested(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class WorkerJobShowOptimizedRouteRequested extends WorkerJobEvent {
  const WorkerJobShowOptimizedRouteRequested();
}
