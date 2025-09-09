import 'package:intl/intl.dart';

/// Date formatting utilities
class DateUtils {
  DateUtils._();

  /// Format date as 'MMM dd, yyyy' (e.g., 'Jan 15, 2024')
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format date as 'EEEE, MMM dd' (e.g., 'Monday, Jan 15')
  static String formatDateWithDay(DateTime date) {
    return DateFormat('EEEE, MMM dd').format(date);
  }

  /// Format date as 'yyyy-MM-dd' for storage
  static String formatDateForStorage(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Get start of week (Monday)
  static DateTime getStartOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: daysFromMonday));
  }

  /// Get end of week (Sunday)
  static DateTime getEndOfWeek(DateTime date) {
    final startOfWeek = getStartOfWeek(date);
    return startOfWeek.add(const Duration(days: 6));
  }

  /// Get days in current week starting from Monday
  static List<DateTime> getDaysInWeek(DateTime date) {
    final startOfWeek = getStartOfWeek(date);
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(date, tomorrow);
  }

  /// Get relative day string (Today, Tomorrow, or formatted date)
  static String getRelativeDayString(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isTomorrow(date)) {
      return 'Tomorrow';
    } else {
      return formatDateWithDay(date);
    }
  }

  /// Add days to a date
  static DateTime addDaysToDate(DateTime date, int days) {
    return date.add(Duration(days: days));
  }
}
