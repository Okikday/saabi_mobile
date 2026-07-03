extension ExtensionOnNum on int {
  // formatToDurationInMinsOr
  String formatDurationSummarized() {
    final totalSeconds = this;
    if (totalSeconds < 3600) {
      final mins = (totalSeconds / 60).round();
      return '$mins mins';
    }
    final hours = (totalSeconds / 3600).round();
    return '$hours hrs';
  }
}
