part of 'worker_job_bloc.dart';

abstract class WorkerJobState extends Equatable {
  const WorkerJobState();

  @override
  List<Object?> get props => [];
}

class WorkerJobInitial extends WorkerJobState {}

class WorkerJobLoading extends WorkerJobState {}

class WorkerJobLoaded extends WorkerJobState {
  final List<WorkerJobEntity> jobs;
  final List<WorkerJobEntity>? optimizedRouteOrder;

  const WorkerJobLoaded({
    required this.jobs,
    this.optimizedRouteOrder,
  });

  List<WorkerJobEntity> get pendingJobs =>
      jobs.where((j) => j.status != WorkerJobStatus.done).toList();

  @override
  List<Object?> get props => [jobs, optimizedRouteOrder];
}

class WorkerJobError extends WorkerJobState {
  final String message;

  const WorkerJobError(this.message);

  @override
  List<Object?> get props => [message];
}
