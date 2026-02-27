import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/worker_job_entity.dart';
import '../../domain/repositories/worker_job_repository.dart';

class WorkerJobRepositoryImpl implements WorkerJobRepository {
  final SharedPreferences _prefs;

  WorkerJobRepositoryImpl({required SharedPreferences sharedPreferences})
      : _prefs = sharedPreferences;

  @override
  Future<List<WorkerJobEntity>> getAssignedJobs() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      WorkerJobEntity(
        id: 'job_1',
        title: 'تنظيف المنطقة أ - حاوية التحرير',
        description: 'تنظيف حاوية النفايات وإفراغها في المنطقة أ',
        type: WorkerJobType.cleaning,
        status: WorkerJobStatus.pending,
        latitude: 30.0444,
        longitude: 31.2357,
        address: 'ميدان التحرير',
      ),
      WorkerJobEntity(
        id: 'job_2',
        title: 'صيانة حاوية زمالك',
        description: 'إصلاح عطل في حاوية زمالك - الحاوية لا تُغلق جيداً',
        type: WorkerJobType.fixing,
        status: WorkerJobStatus.pending,
        latitude: 30.0626,
        longitude: 31.2197,
        address: 'زمالك',
      ),
      WorkerJobEntity(
        id: 'job_3',
        title: 'تنظيف حاوية هليوبوليس',
        description: 'تنظيف وتطهير حاوية هليوبوليس',
        type: WorkerJobType.cleaning,
        status: WorkerJobStatus.pending,
        latitude: 30.0875,
        longitude: 31.3200,
        address: 'هليوبوليس',
      ),
      WorkerJobEntity(
        id: 'job_4',
        title: 'صيانة حاوية المعادي',
        description: 'استبدال مستشعر الحاوية التالف',
        type: WorkerJobType.fixing,
        status: WorkerJobStatus.pending,
        latitude: 29.9600,
        longitude: 31.2600,
        address: 'المعادي',
      ),
      WorkerJobEntity(
        id: 'job_5',
        title: 'تنظيف حاوية مدينة نصر',
        description: 'تنظيف وإفراغ حاوية مدينة نصر',
        type: WorkerJobType.cleaning,
        status: WorkerJobStatus.pending,
        latitude: 30.0628,
        longitude: 31.3200,
        address: 'مدينة نصر',
      ),
    ];
  }

  @override
  Future<void> markJobAsDone(String jobId) async {
    // Completion status is kept in page/memory only, not persisted
  }
}
