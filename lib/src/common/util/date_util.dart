import 'package:flutter/cupertino.dart';
import 'package:gig_buddy/core/extensions/context_extensions.dart';
import 'package:gig_buddy/src/common/manager/location_manager.dart';
import 'package:intl/intl.dart';

class DateUtil {
  static String getDate(String date, BuildContext context) {
    final now = DateTime.now();
    final dateTime = DateTime.parse(date);
    final difference = now.difference(dateTime);
    if (difference.inDays == 0) {
      return  context.l10.today;
    } else if (difference.inDays == 1) {
      return context.l10.yesterday;
    } else if (difference.inDays == 2) {
      return context.l10.tomorrow;
    } else {
      if (dateTime.year != now.year) {
        return DateFormat('dd MMMM yyyy').format(dateTime);
      } else {
        return DateFormat('dd MMMM').format(dateTime);
      }
    }
  }
  static String getBirthDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }
}
