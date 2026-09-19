import 'package:flutter/material.dart';

import '../../core/auth/auth_navigation.dart';
import '../../core/auth/models/account_role.dart';
import '../../core/auth/services/mock_auth_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import 'auth_widgets.dart';
import 'invitation_activation_screen.dart';

class InvitationActivationScreenState extends State<InvitationActivationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _activate() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (!email.contains('@') || password.length < 6) {
      setState(() => _error = widget.role == AccountRole.patient ? 'أدخل بريد المريض الصحيح وكلمة مرور من ٦ أحرف أو أكثر.' : 'أدخل البريد المدعو وكلمة مرور من ٦ أحرف أو أكثر.');
      return;
    }
    setState(() {
      _error = null;
      _loading = true;
    });
    final result = widget.role == AccountRole.patient
        ? await MockAuthRepository.instance.activatePatientAccount(email: email, password: password)
        : await MockAuthRepository.instance.activateInvitation(role: widget.role, email: email, password: password);
    if (!mounted) return;
    setState(() => _loading = false);
    if (!result.success) {
      setState(() => _error = result.message);
      return;
    }
    AuthNavigation.openRoleHome(context, widget.role);
  }

  String get _title => switch (widget.role) {
        AccountRole.patient => 'تفعيل حساب المريض',
        AccountRole.doctor => 'تفعيل دعوة الطبيب',
        AccountRole.organization => 'تفعيل المؤسسة',
      };

  String get _subtitle => switch (widget.role) {
        AccountRole.patient => 'أدخل البريد الذي أضافه الطبيب ثم أنشئ كلمة مرور جديدة',
        AccountRole.doctor => 'استخدم البريد الإلكتروني المطابق للدعوة المحلية التجريبية',
        AccountRole.organization => 'استخدم البريد الإلكتروني الخاص بالمؤسسة',
      };

  @override
  Widget build(BuildContext context) => AuthScaffold(
        showBack: true,
        title: _title,
        subtitle: _subtitle,
        children: [
          CustomTextField(label: widget.role == AccountRole.patient ? 'البريد الإلكتروني للمريض' : 'البريد الإلكتروني المدعو', prefixIcon: Icons.email_outlined, controller: _emailController, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(label: 'كلمة مرور جديدة', prefixIcon: Icons.lock_outline_rounded, controller: _passwordController, obscureText: true, textInputAction: TextInputAction.done, onSubmitted: (_) => _activate()),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(_error!, style: const TextStyle(color: Color(0xFFC84C4C), fontWeight: FontWeight.w700)),
          ],
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(label: widget.role == AccountRole.patient ? 'تفعيل الحساب' : 'تفعيل الحساب محلياً', icon: Icons.verified_user_outlined, onPressed: _activate, isLoading: _loading),
          const SizedBox(height: AppSpacing.md),
          Text(widget.role == AccountRole.patient ? 'لا يتم إرسال بريد فعلي. استخدم البريد نفسه الذي أضافه الطبيب.' : 'لا يتم إرسال بريد فعلي. هذه الدعوة محفوظة في الذاكرة لمحاكاة التكامل المستقبلي.', style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
}
