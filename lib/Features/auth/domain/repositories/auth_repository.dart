import '../entities/user_entity.dart';
import '../../../../core/shared/constants/user_types.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String username,
    required String password,
    UserType? userType,
  });

  Future<UserEntity> register({
    required String username,
    required String password,
    required String confirmPassword,
    required UserType userType,
    String? companyPassword,
  });

  Future<void> logout();

  Future<UserEntity?> getCurrentUser();

  Future<bool> isAuthenticated();
}
