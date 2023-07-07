import 'package:intl/intl.dart';

class StringUtils {
  static String capitalize(String value) {
    return (value.isNotEmpty)
        ? value[0].toUpperCase() + value.substring(1)
        : value[0].toUpperCase();
  }

  static String removeAllHtmlTags(String htmlText) {
    final pattern = RegExp(
      '<.*?>|&.*?;',
      multiLine: true,
      caseSensitive: false,
    );
    return htmlText.replaceAll(pattern, '');
  }

  static String formatDate(DateTime dateTime) {
    String dateTimeString = dateTime.toString();
    DateTime dateTimeParse = DateTime.parse(dateTimeString);
    return '${dateTimeParse.year}${dateTimeParse.month.toString().padLeft(2, '0')}${dateTimeParse.day.toString().padLeft(2, '0')}';
  }

  static String midnightDate(DateTime dateTime) {
    DateTime dateToParse = DateTime.parse(dateTime.toString());
    DateTime midnightDateTime =
        DateTime(dateToParse.year, dateToParse.month, dateToParse.day);
    return midnightDateTime.toString();
  }

  static String monthDate(DateTime dateTime) {
    DateTime dateToParse = DateTime.parse(dateTime.toString());
    DateFormat monthDate = DateFormat('MMMM');
    return monthDate.format(dateToParse);
  }

  static String hoursDate(DateTime dateTime) {
    String dateTimeString = dateTime.toString();
    DateTime dateToParse = DateTime.parse(dateTimeString);
    return '${dateToParse.hour.toString().padLeft(2, '0')}:${dateToParse.minute.toString().padLeft(2, '0')}';
  }

  static String yyyyMMddWithStripe(DateTime dateTime) {
    String dateTimeString = dateTime.toString();
    DateTime dateToParse = DateTime.parse(dateTimeString);

    return '${dateToParse.year}-${dateToParse.month.toString().padLeft(2, '0')}-${dateToParse.day.toString().padLeft(2, '0')}';
  }

  static String formattedRange(String date1String, String date2String) {
    DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    DateFormat outputFormat = DateFormat('dd MMMM');

    DateTime date1 = inputFormat.parse(date1String);
    DateTime date2 = inputFormat.parse(date2String);

    String formattedDate1 = outputFormat.format(date2);
    String formattedDate2 = outputFormat.format(date1);

    if (date1.year != date2.year) {
      return '$formattedDate1 ${date2.year} - $formattedDate2 ${date1.year}';
    } else {
      return '$formattedDate1 - $formattedDate2 ${date1.year}';
    }
  }

  // Output: 2023-06-21
  static String formatTanggal(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return dateTime.toIso8601String().split('T')[0];
  }

  static String formatTanggalJam(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
  }

  static String trimmedDate(DateTime dateTime) {
    return dateTime.toString().substring(0, 23);
  }
}
