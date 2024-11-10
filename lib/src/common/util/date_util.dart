import 'package:intl/intl.dart';

class DateUtil {
  static String getDate(String date) {
    final now = DateTime.now();
    final dateTime = DateTime.parse(date);
    final difference = now.difference(dateTime);
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays == 2) {
      return 'Tomorrow';
    } else {
      return DateFormat.yMMMMd().format(dateTime);
    }
  }
}
