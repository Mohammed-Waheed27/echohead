import '../entities/worker_job_entity.dart';

abstract class WorkerJobRepository {
  Future<List<WorkerJobEntity>> getAssignedJobs();
  Future<void> markJobAsDone(String jobId);
}
