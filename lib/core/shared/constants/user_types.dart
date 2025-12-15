enum UserType {
  admin,
  supervisor,
  worker,
  user,
}

extension UserTypeExtension on UserType {
  String get displayName {
    switch (this) {
      case UserType.admin:
        return 'مدير';
      case UserType.supervisor:
        return 'مشرف';
      case UserType.worker:
        return 'عامل';
      case UserType.user:
        return 'مستخدم';
    }
  }
}

