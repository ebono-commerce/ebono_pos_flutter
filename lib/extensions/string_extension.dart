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
