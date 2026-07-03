class DateFormatter {
  /// Takes a date string in the format "dd/MM/yyyy" and returns a DateTime object.
  static DateTime? splitAndParseDate(String dateStr) {
    try {
      final dateParts = dateStr.trim().split("/");
      if (dateParts.length != 3) return null;
      return DateTime(int.parse(dateParts.last), int.parse(dateParts[1]), int.parse(dateParts[0]));
    } catch (e) {
      return null;
    }
  }
}
