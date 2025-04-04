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
  bool enabled = true,
  bool filled = true,
}) {
  return TextFormField(
    focusNode: focusNode,
    obscureText: obscureText,
    controller: controller,
    validator: validator,
    readOnly: readOnly,
    maxLength: acceptableLength,
    decoration: textFieldDecoration(
      filled: filled,
      enabled: enabled,
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
  bool filled = true,
  bool enabled = true,
  String? suffixLabel,
  Widget? prefixIcon,
  Widget? suffixWidget,
  String? helperText,
  TextStyle? helperTextStyle,
}) {
  return InputDecoration(
    filled: filled,
    prefixIcon: prefixIcon,
    fillColor: enabled
        ? isFocused
            ? CustomColors.accentColor
            : Colors.white
        : CustomColors.disabledTextFormFieldBackground,
    labelText: label,
    labelStyle: TextStyle(color: CustomColors.enabledLabelColor),
    floatingLabelStyle: TextStyle(backgroundColor: Colors.white),
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
