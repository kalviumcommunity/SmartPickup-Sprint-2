import 'package:flutter/material.dart';

/// A reusable styled text-field used across forms.
///
/// Usage:
/// ```dart
/// CustomTextField(
///   controller: _emailController,
///   label: 'Email',
///   hint: 'you@example.com',
///   icon: Icons.email_outlined,
///   keyboardType: TextInputType.emailAddress,
/// )
/// ```
class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      maxLines: widget.obscureText ? 1 : widget.maxLines,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.icon != null ? Icon(widget.icon, color: Colors.green) : null,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }
}
