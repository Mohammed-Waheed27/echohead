import 'package:equatable/equatable.dart';
import '../../../../core/shared/constants/user_types.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final String email;
  final UserType userType;
  final String? areaId; // For supervisors and workers
  final String? supervisorId; // For workers

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.userType,
    this.areaId,
    this.supervisorId,
  });

  @override
  List<Object?> get props => [id, username, email, userType, areaId, supervisorId];
}

