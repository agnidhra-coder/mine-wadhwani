import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final String? prefixText;
  final int? maxLength;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.focusNode,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.prefixText,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      maxLength: maxLength,
      inputFormatters: maxLength != null
          ? [LengthLimitingTextInputFormatter(maxLength!)]
          : null,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        prefixText: prefixText,
        suffixIcon: suffixIcon,
        errorText: errorText,
        counterText: '',
      ),
    );
  }
}