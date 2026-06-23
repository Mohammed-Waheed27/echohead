import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Thrown when a report Firebase operation fails with a user-friendly message.
class ReportServiceException implements Exception {
  final String message;

  const ReportServiceException(this.message);

  @override
  String toString() => message;
}

class FirebaseErrorHelper {
  FirebaseErrorHelper._();

  static const String timeoutMessage =
      'استغرق الاتصال وقتاً طويلاً.\n'
      'تحقق من الإنترنت وأعد المحاولة. سيتم استخدام قاعدة البيانات البديلة تلقائياً.';

  static const String firestoreNotEnabledMessage =
      'Cloud Firestore غير مفعّل في مشروع Firebase.\n'
      'افتح Firebase Console → Build → Firestore Database → Create database، '
      'ثم أعد تشغيل التطبيق.';

  static String toUserMessage(Object error) {
    if (error is ReportServiceException) return error.message;

    if (error is FirebaseException) {
      return _fromFirebaseCode(error.code, error.message);
    }

    final raw = error.toString().toLowerCase();
    if (raw.contains('timeoutexception') || raw.contains('timed out')) {
      return timeoutMessage;
    }
    if (_isFirestoreConnectionError(raw)) {
      return firestoreNotEnabledMessage;
    }
    if (raw.contains('permission') || raw.contains('denied')) {
      return 'لا توجد صلاحية للوصول إلى البيانات. تحقق من قواعد Firestore.';
    }
    if (raw.contains('network') || raw.contains('internet')) {
      return 'تحقق من اتصال الإنترنت وحاول مرة أخرى.';
    }

    return 'حدث خطأ أثناء الاتصال بـ Firebase. حاول مرة أخرى.';
  }

  static Never rethrowAsReportException(Object error) {
    throw ReportServiceException(toUserMessage(error));
  }

  static bool _isFirestoreConnectionError(String raw) {
    return raw.contains('unable to establish connection') ||
        raw.contains('cloud_firestore') ||
        raw.contains('firestore') && raw.contains('unavailable') ||
        raw.contains('not-found') && raw.contains('database');
  }

  static String _fromFirebaseCode(String code, String? message) {
    switch (code) {
      case 'unavailable':
      case 'unknown':
      case 'not-found':
        return firestoreNotEnabledMessage;
      case 'permission-denied':
        return 'لا توجد صلاحية للوصول إلى البيانات. تحقق من قواعد Firestore.';
      case 'failed-precondition':
        if (message != null && message.toLowerCase().contains('index')) {
          return 'فهرس Firestore غير جاهز بعد. انتظر دقائق ثم أعد المحاولة.';
        }
        return 'Firestore غير جاهز بعد. حاول مرة أخرى بعد قليل.';
      case 'deadline-exceeded':
        return timeoutMessage;
      default:
        return toUserMessage(Exception(message ?? code));
    }
  }
}
