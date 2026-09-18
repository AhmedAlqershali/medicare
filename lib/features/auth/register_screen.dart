import 'package:flutter/material.dart';

import 'auth_screens.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _errors = <String, String?>{};
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final errors = <String, String?>{
      'name': _nameController.text.trim().isEmpty ? 'أدخل الاسم الكامل' : null,
      'contact': _contactController.text.trim().isEmpty ? 'أدخل رقم الجوال أو البريد الإلكتروني' : null,
      'password': _passwordController.text.length < 6 ? 'استخدم ٦ أحرف أو أكثر' : null,
      'confirm': _confirmPasswordController.text != _passwordController.text ? 'كلمتا المرور غير متطابقتين' : null,
    };
    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
    });
    if (errors.values.any((error) => error != null)) return;
    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => const UserTypeScreen()));
  }

  void _clearError(String key) {
    if (_errors[key] == null) return;
    setState(() => _errors[key] = null);
  }

  @override
  Widget build(BuildContext context) => AuthScaffold(
        showBack: true,
        title: 'أنشئ حسابك',
        subtitle: 'ابدأ رحلة رعاية صحية أكثر سهولة',
        children: [
          CustomTextField(label: 'الاسم الكامل', prefixIcon: Icons.badge_outlined, controller: _nameController, errorText: _errors['name'], textInputAction: TextInputAction.next, onChanged: (_) => _clearError('name')),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(label: 'رقم الجوال أو البريد الإلكتروني', prefixIcon: Icons.contact_page_outlined, controller: _contactController, errorText: _errors['contact'], keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, onChanged: (_) => _clearError('contact')),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(label: 'كلمة المرور', prefixIcon: Icons.lock_outline_rounded, controller: _passwordController, obscureText: true, errorText: _errors['password'], textInputAction: TextInputAction.next, onChanged: (_) => _clearError('password')),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(label: 'تأكيد كلمة المرور', prefixIcon: Icons.verified_user_outlined, controller: _confirmPasswordController, obscureText: true, errorText: _errors['confirm'], textInputAction: TextInputAction.done, onChanged: (_) => _clearError('confirm')),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(label: 'إنشاء الحساب', onPressed: _register, isLoading: _isLoading),
          const SizedBox(height: AppSpacing.lg),
          AuthPrompt(label: 'لديك حساب بالفعل؟', action: 'تسجيل الدخول', onPressed: () => Navigator.of(context).pop()),
        ],
      );
}