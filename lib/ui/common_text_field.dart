import 'package:flutter/material.dart';
import 'package:kpn_pos_application/constants/custom_colors.dart';

Widget commonTextField({required String label,
  required FocusNode focusNode,
  bool obscureText = false,
  required TextEditingController controller,
  FormFieldValidator<String>? validator,
}) {
  return TextFormField(
    focusNode: focusNode,
    obscureText: obscureText,
    controller: controller,
    validator: validator,
    decoration:
    textFieldDecoration(isFocused: focusNode.hasFocus, label: label),
  );
}

InputDecoration textFieldDecoration({required bool isFocused,
  required String label,
  filled = true,
  Widget? prefixIcon}) {
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
