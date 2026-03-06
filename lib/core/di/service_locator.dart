import 'package:shared_preferences/shared_preferences.dart';
import '../../Features/auth/data/repositories/auth_repository_impl.dart';
import '../../Features/auth/domain/repositories/auth_repository.dart';
import '../../Features/user/data/repositories/report_repository_impl.dart';
import '../../Features/user/domain/repositories/report_repository.dart';
import '../../Features/Worker/data/repositories/worker_job_repository_impl.dart';
import '../../Features/Worker/domain/repositories/worker_job_repository.dart';
import '../data/repositories/bin_repository_impl.dart';
import '../domain/repositories/bin_repository.dart';

class ServiceLocator {
  static SharedPreferences? _sharedPreferences;
  static AuthRepository? _authRepository;
  static ReportRepository? _reportRepository;
  static WorkerJobRepository? _workerJobRepository;
  static BinRepository? _binRepository;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _authRepository = AuthRepositoryImpl(
      sharedPreferences: _sharedPreferences!,
    );
    _reportRepository = ReportRepositoryImpl(
      sharedPreferences: _sharedPreferences!,
    );
    _workerJobRepository = WorkerJobRepositoryImpl(
      sharedPreferences: _sharedPreferences!,
    );
    _binRepository = BinRepositoryImpl();
  }

  static AuthRepository get authRepository {
    if (_authRepository == null) {
      throw Exception('ServiceLocator not initialized. Call init() first.');
    }
    return _authRepository!;
  }

  static ReportRepository get reportRepository {
    if (_reportRepository == null) {
      throw Exception('ServiceLocator not initialized. Call init() first.');
    }
    return _reportRepository!;
  }

  static WorkerJobRepository get workerJobRepository {
    if (_workerJobRepository == null) {
      throw Exception('ServiceLocator not initialized. Call init() first.');
    }
    return _workerJobRepository!;
  }

  static SharedPreferences get sharedPreferences {
    if (_sharedPreferences == null) {
      throw Exception('ServiceLocator not initialized. Call init() first.');
    }
    return _sharedPreferences!;
  }

  static BinRepository get binRepository {
    if (_binRepository == null) {
      throw Exception('ServiceLocator not initialized. Call init() first.');
    }
    return _binRepository!;
  }
}

