enum AuthModes {
  enabled,
  disabled,
  authorised,
}

extension AuthModeExtension on AuthModes {
  static AuthModes fromString(String value) {
    switch (value.toUpperCase()) {
      case "ENABLED":
        return AuthModes.enabled;
      case "DISABLED":
        return AuthModes.disabled;
      case "ENABLED_WITH_AUTH":
        return AuthModes.authorised;
      default:
        return AuthModes.disabled;
    }
  }
}
