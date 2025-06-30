/// String extension that provides additional string manipulation methods.
extension StringExtension on String {
  /// Converts a string to title case where the first letter of each word is capitalized
  /// and the remaining letters are in lowercase.
  ///
  /// Example:
  /// ```dart
  /// "EXISTING CUSTOMER VERIFIED".toTitleCase() // Returns "Existing Customer Verified"
  /// "hello WORLD".toTitleCase() // Returns "Hello World"
  /// ```
  String toTitleCase() {
    // Handle empty string
    if (isEmpty) return this;

    // Split the string into words
    return split(' ').map((word) {
      // Handle empty words
      if (word.isEmpty) return word;

      // Convert the entire word to lowercase first
      word = word.toLowerCase();
      // Capitalize the first letter
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}

extension DecimalStringValidator on String {
  /// Trims the string to maximum [decimalRange] digits after decimal point.
  /// If more than one decimal exists, returns original string.
  String limitDecimalDigits({required int decimalRange}) {
    if (this.isEmpty) return this;

    if (this.contains('.') && this.indexOf('.') != this.lastIndexOf('.')) {
      return this;
    }

    final parts = this.split('.');

    if (parts.length == 1) {
      return this;
    }

    final whole = parts[0];
    final decimal =
        parts[1].substring(0, decimalRange.clamp(0, parts[1].length));

    return '$whole.$decimal';
  }
}
