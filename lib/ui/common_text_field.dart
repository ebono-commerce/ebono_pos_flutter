import 'package:flutter/material.dart';
import 'package:kpn_pos_application/constants/custom_colors.dart';

Widget commonTextField(
    {required String label,
    required FocusNode focusNode,
    bool obscureText = false,
    bool readOnly = false,
    required TextEditingController controller,
    FormFieldValidator<String>? validator,
    Function(String)? onValueChanged,
    Function()? onTap,
    String? suffixLabel = '',
    Widget? suffixWidget}) {
  return TextFormField(
    focusNode: focusNode,
    obscureText: obscureText,
    controller: controller,
    validator: validator,
    readOnly: readOnly,
    decoration: textFieldDecoration(
        isFocused: focusNode.hasFocus,
        label: label,
        suffixLabel: suffixLabel,
        suffixWidget: suffixWidget),
    onTap: () {
      onTap;
    },
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
      suffix: suffixWidget);
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
