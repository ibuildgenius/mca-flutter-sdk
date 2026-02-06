import 'package:intl/intl.dart';

class CustomDateUtils {
  static String convertStringDate(String dateString) {
    // Parse the input date string
    DateTime date = DateTime.parse(dateString);

    // Format the date to "18th Jul 2006"
    String day = DateFormat('d').format(date);
    String suffix = getDaySuffix(int.parse(day));
    String formattedDate =
        DateFormat("d'th' MMM yyyy").format(date).replaceFirst('th', suffix);

    return formattedDate;
  }

  static String convertDate(DateTime date) {
    // Format the date to "18th Jul 2006"
    String day = DateFormat('d').format(date);
    String suffix = getDaySuffix(int.parse(day));
    String formattedDate =
        DateFormat("d'th' MMM yyyy").format(date).replaceFirst('th', suffix);

    return formattedDate;
  }

  static String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
