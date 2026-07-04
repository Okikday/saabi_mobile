/// Computes the Levenshtein (edit) distance between two strings.
/// Used for fuzzy matching user input against known keywords.
int levenshtein(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;

  final List<int> prev = List<int>.generate(b.length + 1, (i) => i);
  final List<int> curr = List<int>.filled(b.length + 1, 0);

  for (int i = 1; i <= a.length; i++) {
    curr[0] = i;
    for (int j = 1; j <= b.length; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      curr[j] = [
        curr[j - 1] + 1,
        prev[j] + 1,
        prev[j - 1] + cost,
      ].reduce((a, b) => a < b ? a : b);
    }
    prev.setAll(0, curr);
  }
  return curr[b.length];
}

/// Returns true if [input] fuzzy-matches [target] within [maxDistance] edits.
bool fuzzyMatch(String input, String target, {int maxDistance = 2}) {
  return levenshtein(input.toLowerCase(), target.toLowerCase()) <= maxDistance;
}
