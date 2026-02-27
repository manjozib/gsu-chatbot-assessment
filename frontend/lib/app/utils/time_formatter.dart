import 'package:intl/intl.dart';

class TimeFormatter {
  static String format(DateTime dateTime) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final difference = today.difference(inputDate).inDays;

    if (difference == 0) {
      return DateFormat('HH:mm').format(dateTime);
    }

    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    if (dateTime.isAfter(startOfWeek)) {
      return DateFormat('EEE HH:mm').format(dateTime);
    }

    if (dateTime.year == now.year) {
      return DateFormat('MMM d, HH:mm').format(dateTime);
    }

    return DateFormat('MMM d, yyyy').format(dateTime);
  }
}