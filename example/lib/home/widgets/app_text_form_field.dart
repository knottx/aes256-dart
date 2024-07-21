import 'package:flutter/material.dart';

class AppTextFormField extends TextFormField {
  AppTextFormField({
    super.key,
    super.controller,
    super.focusNode,
    super.keyboardType,
    super.obscureText,
    super.maxLength,
    super.textAlign,
    super.style,
    super.validator,
    super.onSaved,
    super.inputFormatters,
    super.autofillHints,
    super.textCapitalization,
    bool? filled,
    Color? fillColor,
    String? labelText,
    String? hintText,
    String? counterText = '',
    int maxLines = 1,
  }) : super(
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: filled,
            fillColor: fillColor,
            labelText: labelText,
            hintText: hintText,
            contentPadding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: maxLines > 1 ? 16 : 8,
              bottom: maxLines > 1 ? 16 : 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                width: 1,
              ),
            ),
            counterText: counterText,
          ),
        );
}
