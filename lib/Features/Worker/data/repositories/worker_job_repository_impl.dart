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
        title: 'تنظيف المنطقة أ - حاوية وسط المنزلة',
        description: 'تنظيف حاوية النفايات وإفراغها في المنطقة أ',
        type: WorkerJobType.cleaning,
        status: WorkerJobStatus.pending,
        latitude: 31.1582,
        longitude: 31.9360,
        address: 'وسط مدينة المنزلة',
      ),
      WorkerJobEntity(
        id: 'job_2',
        title: 'صيانة حاوية كلية المنزلة',
        description: 'إصلاح عطل في حاوية كلية المنزلة - الحاوية لا تُغلق جيداً',
        type: WorkerJobType.fixing,
        status: WorkerJobStatus.pending,
        latitude: 31.1620,
        longitude: 31.9320,
        address: 'محيط كلية المنزلة',
      ),
      WorkerJobEntity(
        id: 'job_3',
        title: 'تنظيف حاوية شرق المنزلة',
        description: 'تنظيف وتطهير حاوية شرق المنزلة',
        type: WorkerJobType.cleaning,
        status: WorkerJobStatus.pending,
        latitude: 31.1550,
        longitude: 31.9400,
        address: 'شرق المنزلة',
      ),
      WorkerJobEntity(
        id: 'job_4',
        title: 'صيانة حاوية غرب المنزلة',
        description: 'استبدال مستشعر الحاوية التالف',
        type: WorkerJobType.fixing,
        status: WorkerJobStatus.pending,
        latitude: 31.1520,
        longitude: 31.9300,
        address: 'غرب المنزلة',
      ),
      WorkerJobEntity(
        id: 'job_5',
        title: 'تنظيف حاوية شمال المنزلة',
        description: 'تنظيف وإفراغ حاوية شمال المنزلة - قرب الكلية',
        type: WorkerJobType.cleaning,
        status: WorkerJobStatus.pending,
        latitude: 31.1650,
        longitude: 31.9380,
        address: 'شمال المنزلة - قرب الكلية',
      ),
    ];
  }

  @override
  Future<void> markJobAsDone(String jobId) async {
    // Completion status is kept in page/memory only, not persisted
  }
}
