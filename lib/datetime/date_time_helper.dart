// convert DateTime object to a string

String convertDateTimeToString(DateTime dateTime) {
  // year in the format -> yyyy
  String year = dateTime.year.toString();

  // same for the month
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0' + month;
  }

  // same for the day
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0' + day;
  }

  // final format
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}
