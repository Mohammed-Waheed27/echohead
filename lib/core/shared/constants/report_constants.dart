class ReportConstants {
  ReportConstants._();

  static const String firestoreCollection = 'reports';
  static const String rtdbReportsPath = 'reports';
  static const String storageFolder = 'report_images';

  /// Resolved reports are auto-deleted after this duration.
  static const int resolvedRetentionMinutes = 25;

  static const String guestUserIdKey = 'guest_user_id';

  /// Cached backend: 'firestore' or 'rtdb'
  static const String backendPreferenceKey = 'report_backend_preference';
}
