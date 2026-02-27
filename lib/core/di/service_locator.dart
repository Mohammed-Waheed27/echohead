import 'package:shared_preferences/shared_preferences.dart';
import '../../Features/auth/data/repositories/auth_repository_impl.dart';
import '../../Features/auth/domain/repositories/auth_repository.dart';
import '../../Features/user/data/repositories/report_repository_impl.dart';
import '../../Features/user/domain/repositories/report_repository.dart';

class ServiceLocator {
  static SharedPreferences? _sharedPreferences;
  static AuthRepository? _authRepository;
  static ReportRepository? _reportRepository;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _authRepository = AuthRepositoryImpl(
      sharedPreferences: _sharedPreferences!,
    );
    _reportRepository = ReportRepositoryImpl(
      sharedPreferences: _sharedPreferences!,
    );
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

  static SharedPreferences get sharedPreferences {
    if (_sharedPreferences == null) {
      throw Exception('ServiceLocator not initialized. Call init() first.');
    }
    return _sharedPreferences!;
  }
}

