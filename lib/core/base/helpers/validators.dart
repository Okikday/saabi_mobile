class Validators {
  const Validators();
  static String? validatePassword(String? text) {
    if (text == null || text.trim().isEmpty) return "Please enter a valid password";
    final pass = text.trim();

    if (pass.length < 8) return "Password is too short";
    final hasUpper = RegExp(r'[A-Z]').hasMatch(pass);
    final hasLower = RegExp(r'[a-z]').hasMatch(pass);
    final hasDigit = RegExp(r'\d').hasMatch(pass);
    final hasSpecial = RegExp(r'[\W_]').hasMatch(pass);

    final strength = [hasUpper, hasLower, hasDigit, hasSpecial].where((e) => e).length;

    if (strength <= 2) return "Weak password, try more combinations";
    if (strength == 3) return "Almost there, Just some more combinations";
    return null;
  }

  static String? validatePasswordLength(String? text) => text == null || text.trim().isEmpty
      ? "Please enter a valid password"
      : (text.length < 8 ? "Password must have 8 minimum characters" : null);

  static String? validatePasswordSimple(String? text) =>
      text == null || text.trim().isEmpty || text.length < 8 ? "Please enter a valid password" : null;

  static String? validateEmail(String? text) {
    if (text == null || text.trim().isEmpty) return "Please enter a valid email";

    if (text.trim().length < 5 ||
        !text.contains("@") ||
        !text.contains(".") ||
        text.startsWith("@") ||
        text.endsWith("@") ||
        text.startsWith(".") ||
        text.endsWith(".")) {
      return "almost there...";
    }
    final email = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return email.hasMatch(text.trim()) ? null : "Invalid email address";
  }
}
