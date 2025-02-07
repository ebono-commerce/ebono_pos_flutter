import 'package:ebono_pos/constants/custom_colors.dart';
import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final String? labelText;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final String? suffixLabel;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Function(String)? onValueChanged;
  final Function()? onEditingComplete;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool readOnly;
  final Color? fillColor;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? width;
  final double? height;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLength;
  final bool autofocus;
  final bool showCursor;
  final BorderRadius? borderRadius;
  final String? helperText;
  final TextStyle? helperTextStyle;

  const CommonTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.prefixWidget,
    this.suffixWidget,
    this.suffixLabel,
    this.labelText,
    this.obscureText = false,
    this.keyboardType,
    this.onEditingComplete,
    this.onValueChanged,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.fillColor,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.width,
    this.height,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLength,
    this.autofocus = false,
    this.showCursor = true,
    this.borderRadius,
    this.helperText,
    this.helperTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onValueChanged,
        onEditingComplete: onEditingComplete,
        validator: validator,
        enabled: enabled,
        readOnly: readOnly,
        textAlign: textAlign,
        maxLength: maxLength,
        autofocus: autofocus,
        showCursor: showCursor,
        style: style ??
            TextStyle(
              color: textColor ?? Colors.black,
              fontSize: fontSize ?? 16,
              fontWeight: fontWeight ?? FontWeight.normal,
            ),
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: prefixWidget,
          suffixIcon: suffixWidget,
          suffixText: suffixLabel,
          filled: true,
          fillColor: fillColor ??
              (focusNode?.hasFocus == true
                  ? CustomColors.accentColor
                  : Colors.white),
          helperText: helperText,
          helperStyle: helperTextStyle,
          helperMaxLines: 1,
          border: enabledBorder(),
          enabledBorder: enabledBorder(),
          focusedBorder: focusedBorder(),
          errorBorder: errorBorder(),
          focusedErrorBorder: errorBorder(),
        ),
      ),
    );
  }

  OutlineInputBorder enabledBorder() {
    return OutlineInputBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      borderSide: BorderSide(
        color: CustomColors.enabledBorderColor,
        width: 1.0,
      ),
    );
  }

  OutlineInputBorder focusedBorder() {
    return OutlineInputBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      borderSide: BorderSide(
        color: CustomColors.activatedBorderColor,
        width: 1.0,
      ),
    );
  }

  OutlineInputBorder errorBorder() {
    return OutlineInputBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      borderSide: BorderSide(
        color: CustomColors.red,
        width: 1.0,
      ),
    );
  }
}
