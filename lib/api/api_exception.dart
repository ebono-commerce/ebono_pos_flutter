class ApiException implements Exception {
  final String _message;
  final String _prefix;

  ApiException([this._message = "", this._prefix = ""]);

  @override
  String toString() {
    return "$_prefix$_message";
  }

  // Method to trim the exception string
  String getCleanMessage() {
    // Original string: 'Exception: Exception 400 | Invalide OTP'

    // If the string starts with 'Exception: ', remove it
    String cleanMessage = _message;
    if (cleanMessage.startsWith('Exception: ')) {
      cleanMessage = cleanMessage.substring('Exception: '.length);
    }

    // If there's a pattern like 'Exception 400 | ', extract only what's after the pipe
    final RegExp exceptionCodePattern = RegExp(r'Exception \d+ \| ');
    if (exceptionCodePattern.hasMatch(cleanMessage)) {
      final match = exceptionCodePattern.firstMatch(cleanMessage);
      if (match != null) {
        cleanMessage = cleanMessage.substring(match.end);
      }
    }

    return cleanMessage;
  }

  // Factory constructor to create from another exception string
  factory ApiException.fromString(String exceptionString) {
    // Remove 'Exception: ' prefix if it exists
    String message = exceptionString;
    if (message.startsWith('Exception: ')) {
      message = message.substring('Exception: '.length);
    }

    return ApiException(message);
  }
}


