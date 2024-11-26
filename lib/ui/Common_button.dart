import 'package:flutter/material.dart';

ButtonStyle commonElevatedButtonStyle(
    {required ThemeData theme,
      required TextStyle? textStyle,
      required EdgeInsets padding,
      bool isEnabled = true,
     double elevation = 0}) {
  return ElevatedButton.styleFrom(
    foregroundColor: Colors.black87,
    backgroundColor: isEnabled? theme.colorScheme.secondary : Colors.grey,
    textStyle: textStyle?.copyWith(
      fontWeight: FontWeight.w500,
      color: Colors.black
    ),
    padding: padding,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    elevation: elevation,
  );
}
