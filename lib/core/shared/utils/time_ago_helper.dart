import 'package:intl/intl.dart';

/// Formats a DateTime as "Updated X seconds/minutes/hours ago" for real-time feel.
String formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final diff = now.difference(dateTime);

  if (diff.inSeconds < 60) {
    return 'تم التحديث منذ ${diff.inSeconds} ثانية';
  }
  if (diff.inMinutes < 60) {
    return 'تم التحديث منذ ${diff.inMinutes} دقيقة';
  }
  if (diff.inHours < 24) {
    return 'تم التحديث منذ ${diff.inHours} ساعة';
  }
  if (diff.inDays < 7) {
    return 'تم التحديث منذ ${diff.inDays} يوم';
  }
  return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
}
