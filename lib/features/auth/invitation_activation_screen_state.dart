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
    if (!_emailController.text.contains('@') || _passwordController.text.length < 6) {
      setState(() => _error = 'أدخل البريد المدعو وكلمة مرور من ٦ أحرف أو أكثر.');
      return;
    }
    setState(() {
      _error = null;
      _loading = true;
    });
    final result = await MockAuthRepository.instance.activateInvitation(role: widget.role, email: _emailController.text, password: _passwordController.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (!result.success) {
      setState(() => _error = result.message);
      return;
    }
    AuthNavigation.openRoleHome(context, widget.role);
  }

  String get _title => widget.role == AccountRole.doctor ? 'تفعيل دعوة الطبيب' : 'تفعيل دعوة المريض';

  @override
  Widget build(BuildContext context) => AuthScaffold(
        showBack: true,
        title: _title,
        subtitle: 'استخدم البريد الإلكتروني المطابق للدعوة المحلية التجريبية',
        children: [
          CustomTextField(label: 'البريد الإلكتروني المدعو', prefixIcon: Icons.email_outlined, controller: _emailController, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(label: 'كلمة مرور جديدة', prefixIcon: Icons.lock_outline_rounded, controller: _passwordController, obscureText: true, textInputAction: TextInputAction.done, onSubmitted: (_) => _activate()),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(_error!, style: const TextStyle(color: Color(0xFFC84C4C), fontWeight: FontWeight.w700)),
          ],
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(label: 'تفعيل الحساب محلياً', icon: Icons.verified_user_outlined, onPressed: _activate, isLoading: _loading),
          const SizedBox(height: AppSpacing.md),
          Text('لا يتم إرسال بريد فعلي. هذه الدعوة محفوظة في الذاكرة لمحاكاة التكامل المستقبلي.', style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
}
