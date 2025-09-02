import 'package:flutter/material.dart';

class CustomProfileFormField extends StatelessWidget {
  final String labelText;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final IconData? icon;
  final bool obscureText;
  final int maxLines;
  final TextInputType keyboardType;

  const CustomProfileFormField({
    super.key,
    required this.labelText,
    this.initialValue,
    this.onChanged,
    this.icon,
    this.obscureText = false,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
