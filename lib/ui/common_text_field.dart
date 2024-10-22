import 'package:flutter/material.dart';
import 'package:kpn_pos_application/constants/custom_colors.dart';

Widget commonTextField(
    {required String label,
    required FocusNode focusNode,
    bool obscureText = false,
    required TextEditingController controller}) {
  return TextField(
    focusNode: focusNode,
    obscureText: obscureText,
    controller: controller,
    decoration:
        textFieldDecoration(isFocused: focusNode.hasFocus, label: label),
  );
}

InputDecoration textFieldDecoration(
    {required bool isFocused,
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
      focusedBorder: focusedBorder());
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
