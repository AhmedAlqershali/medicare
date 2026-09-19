import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.label, this.hintText, this.prefixIcon, this.controller, this.obscureText = false, this.keyboardType, this.onChanged, this.errorText, this.validator, this.textInputAction, this.autofillHints});
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) => _TextField(
        label: label,
        hintText: hintText,
        prefixIcon: prefixIcon,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        errorText: errorText,
        validator: validator,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
      );
}

class _TextField extends StatefulWidget {
  const _TextField({required this.label, this.hintText, this.prefixIcon, this.controller, required this.obscureText, this.keyboardType, this.onChanged, this.errorText, this.validator, this.textInputAction, this.autofillHints});
  final String label;
  final String? hintText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;

  @override
  State<_TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> {
  late bool _isObscured = widget.obscureText;

  @override
  void didUpdateWidget(covariant _TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        obscureText: _isObscured,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        autofillHints: widget.autofillHints,
        onChanged: widget.onChanged,
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hintText,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon == null ? null : Icon(widget.prefixIcon),
          suffixIcon: widget.obscureText
              ? IconButton(
                  onPressed: () => setState(() => _isObscured = !_isObscured),
                  icon: Icon(_isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  tooltip: _isObscured ? 'إظهار كلمة المرور' : 'إخفاء كلمة المرور',
                )
              : null,
        ),
      );
}