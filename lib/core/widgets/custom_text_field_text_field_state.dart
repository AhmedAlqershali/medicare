part of 'custom_text_field.dart';

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
        onFieldSubmitted: widget.onSubmitted,
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
