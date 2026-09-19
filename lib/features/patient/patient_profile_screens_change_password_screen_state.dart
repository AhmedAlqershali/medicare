part of 'patient_profile_screens.dart';

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  final Map<String, String> _errors = {};
  bool _success = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _changePassword() {
    final errors = <String, String>{};
    if (_currentController.text.isEmpty) errors['current'] = 'أدخل كلمة المرور الحالية';
    if (_newController.text.length < 6) errors['new'] = 'يجب أن تتكون من 6 أحرف على الأقل';
    if (_confirmController.text.isEmpty || _confirmController.text != _newController.text) errors['confirm'] = 'كلمتا المرور غير متطابقتين';
    setState(() {
      _errors
        ..clear()
        ..addAll(errors);
      _success = errors.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('تغيير كلمة المرور')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(children: [
              CustomTextField(label: 'كلمة المرور الحالية', prefixIcon: Icons.lock_outline, controller: _currentController, obscureText: true, errorText: _errors['current'], textInputAction: TextInputAction.next),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'كلمة المرور الجديدة', prefixIcon: Icons.lock_reset_outlined, controller: _newController, obscureText: true, errorText: _errors['new'], textInputAction: TextInputAction.next),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'تأكيد كلمة المرور الجديدة', prefixIcon: Icons.verified_user_outlined, controller: _confirmController, obscureText: true, errorText: _errors['confirm'], textInputAction: TextInputAction.done),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(label: 'تغيير كلمة المرور', icon: Icons.check_rounded, onPressed: _changePassword),
              if (_success) ...[
                const SizedBox(height: AppSpacing.md),
                Text('تم تغيير كلمة المرور محلياً بنجاح.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.success, fontWeight: FontWeight.w700)),
              ],
            ]),
          ),
        ),
      );
}
