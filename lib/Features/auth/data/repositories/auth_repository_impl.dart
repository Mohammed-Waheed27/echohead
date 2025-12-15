import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/shared/constants/user_types.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({required this.sharedPreferences});

  @override
  Future<UserEntity> login({
    required String username,
    required String password,
    UserType? userType,
  }) async {
    // TODO: Implement actual API call
    // For now, simulate login
    await Future.delayed(const Duration(seconds: 1));

    final user = UserEntity(
      id: '1',
      username: username,
      email: '$username@example.com',
      userType: userType ?? UserType.user,
    );

    await sharedPreferences.setString('user_id', user.id);
    await sharedPreferences.setString('username', user.username);
    await sharedPreferences.setString('user_type', user.userType.name);

    return user;
  }

  @override
  Future<UserEntity> register({
    required String username,
    required String password,
    required String confirmPassword,
    required UserType userType,
    String? companyPassword,
  }) async {
    // TODO: Implement actual API call
    // For now, simulate registration
    await Future.delayed(const Duration(seconds: 1));

    final user = UserEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
      email: '$username@example.com',
      userType: userType,
    );

    await sharedPreferences.setString('user_id', user.id);
    await sharedPreferences.setString('username', user.username);
    await sharedPreferences.setString('user_type', user.userType.name);

    return user;
  }

  @override
  Future<void> logout() async {
    await sharedPreferences.remove('user_id');
    await sharedPreferences.remove('username');
    await sharedPreferences.remove('user_type');
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userId = sharedPreferences.getString('user_id');
    final username = sharedPreferences.getString('username');
    final userTypeString = sharedPreferences.getString('user_type');

    if (userId == null || username == null || userTypeString == null) {
      return null;
    }

    final userType = UserType.values.firstWhere(
      (type) => type.name == userTypeString,
      orElse: () => UserType.user,
    );

    return UserEntity(
      id: userId,
      username: username,
      email: '$username@example.com',
      userType: userType,
    );
  }

  @override
  Future<bool> isAuthenticated() async {
    final userId = sharedPreferences.getString('user_id');
    return userId != null;
  }
}
