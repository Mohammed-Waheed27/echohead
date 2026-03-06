/// Allowed usernames for worker and supervisor login.
/// Only users in these lists can log in as the respective role.
class AllowedUsernames {
  AllowedUsernames._();

  /// 10 usernames allowed to log in as supervisor
  static const List<String> supervisors = [
    'ahmed_supervisor',
    'mohammed_supervisor',
    'ali_supervisor',
    'omar_supervisor',
    'khalid_supervisor',
    'hassan_supervisor',
    'youssef_supervisor',
    'ibrahim_supervisor',
    'mahmoud_supervisor',
    'saleh_supervisor',
  ];

  /// 10 usernames allowed to log in as worker
  static const List<String> workers = [
    'ahmed_worker',
    'mohammed_worker',
    'ali_worker',
    'omar_worker',
    'khalid_worker',
    'hassan_worker',
    'youssef_worker',
    'ibrahim_worker',
    'mahmoud_worker',
    'saleh_worker',
  ];

  static bool isAllowedSupervisor(String username) {
    return supervisors
        .any((u) => u.toLowerCase() == username.trim().toLowerCase());
  }

  static bool isAllowedWorker(String username) {
    return workers.any((u) => u.toLowerCase() == username.trim().toLowerCase());
  }
}
