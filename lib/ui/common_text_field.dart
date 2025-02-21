import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:flutter/material.dart';

Widget commonTextField({
  required String label,
  required FocusNode focusNode,
  bool obscureText = false,
  bool readOnly = false,
  required TextEditingController controller,
  FormFieldValidator<String>? validator,
  Function(String)? onValueChanged,
  Function()? onEditingComplete,
  Function()? onTap,
  String? suffixLabel,
  Widget? suffixWidget,
  String? helperText,
  TextStyle? helperTextStyle,
  int? acceptableLength,
}) {
  return TextFormField(
    focusNode: focusNode,
    obscureText: obscureText,
    controller: controller,
    validator: validator,
    readOnly: readOnly,
    maxLength: acceptableLength,
    decoration: textFieldDecoration(
      isFocused: focusNode.hasFocus,
      label: label,
      helperText: helperText,
      helperTextStyle: helperTextStyle,
      suffixLabel: suffixLabel,
      suffixWidget: suffixWidget,
    ),
    onTap: onTap,
    onEditingComplete: onEditingComplete,
    onChanged: (value) {
      if (onValueChanged != null) {
        onValueChanged(value);
      }
    },
  );
}

InputDecoration textFieldDecoration({
  required bool isFocused,
  required String label,
  filled = true,
  String? suffixLabel,
  Widget? prefixIcon,
  Widget? suffixWidget,
  String? helperText,
  TextStyle? helperTextStyle,
}) {
  return InputDecoration(
    filled: filled,
    prefixIcon: prefixIcon,
    fillColor: isFocused ? CustomColors.accentColor : Colors.white,
    labelText: label,
    labelStyle: TextStyle(color: CustomColors.enabledLabelColor),
    enabledBorder: enabledBorder(),
    focusedBorder: focusedBorder(),
    errorBorder: errorBorder(),
    focusedErrorBorder: errorBorder(),
    suffixText: suffixLabel,
    suffix: suffixWidget,
    helperText: helperText,
    helperStyle: helperTextStyle,
    helperMaxLines: 1,
    counterText: '',
  );
}

OutlineInputBorder enabledBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: CustomColors.enabledBorderColor,
      width: 1.0,
    ),
  );
}

OutlineInputBorder focusedBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: CustomColors.activatedBorderColor,
      width: 1.0,
    ),
  );
}

OutlineInputBorder errorBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: CustomColors.red, // Set this to your preferred error color
      width: 1.0,
    ),
  );
}
