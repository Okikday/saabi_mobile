class Formatter {
  static String capitalizeLeadingWords(String text) {
    if (text.isEmpty) return text;

    // Insert a space before uppercase letters (for camelCase)
    final spaced = text.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}');

    // Split by spaces, capitalize first letter of each word
    return spaced
        .split(RegExp(r'\s+'))
        .map((word) => word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }

  static String separateEnumWithHyphens(String text) {
    if (text.isEmpty) return text;

    final spaced = text.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}').toLowerCase();
    return spaced.replaceAll(' ', '-');
  }

  static const List<String> _monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  static String formatDateAsMonthYear(DateTime date) {
    final month = _monthNames[date.month - 1];
    final year = date.year;
    return '$month $year';
  }
}

extension ExtensionFormatter on String {
  String capitalizeLeadingWords() => Formatter.capitalizeLeadingWords(this);
}
