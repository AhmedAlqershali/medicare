import 'package:flutter/material.dart';

import '../../core/auth/services/mock_patient_repository.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import '../auth/auth_widgets.dart';
import 'add_patient_screen.dart';

class AddPatientScreenState extends State<AddPatientScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _error;
  bool _success = false;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final doctorId = MockPatientRepository.instance.currentDoctorId;
    if (_nameController.text.trim().isEmpty || !_isEmail(email)) {
      setState(() => _error = 'أدخل اسم المريض وبريداً إلكترونياً صحيحاً.');
      return;
    }
    if (doctorId == null) {
      setState(() => _error = 'لا يوجد طبيب نشط مرتبط بالجلسة الحالية.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      MockPatientRepository.instance.invitePatient(doctorId: doctorId, name: _nameController.text.trim(), email: email, invitedBy: MockPatientRepository.instance.currentInviterId);
      if (mounted) setState(() => _success = true);
    } on StateError catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool _isEmail(String value) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);

  @override
  Widget build(BuildContext context) {
    if (_success) {
      return Scaffold(appBar: AppBar(title: const Text('إضافة مريض')), body: SafeArea(child: Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.mark_email_read_outlined, color: AppColors.success, size: 64), const SizedBox(height: AppSpacing.lg), Text('تمت إضافة المريض وإنشاء دعوة محلية معلقة.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: AppSpacing.sm), Text('لن يتم إرسال بريد فعلي في هذه المرحلة.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium), const SizedBox(height: AppSpacing.xl), PrimaryButton(label: 'العودة إلى المرضى', onPressed: () => Navigator.of(context).pop())]))));
    }
    return AuthScaffold(showBack: true, title: 'إضافة مريض', subtitle: 'أضف المريض إلى قائمتك وأنشئ دعوة محلية', children: [CustomTextField(label: 'اسم المريض', prefixIcon: Icons.badge_outlined, controller: _nameController), const SizedBox(height: AppSpacing.md), CustomTextField(label: 'البريد الإلكتروني الشخصي', prefixIcon: Icons.email_outlined, controller: _emailController, keyboardType: TextInputType.emailAddress), if (_error != null) ...[const SizedBox(height: AppSpacing.sm), Text(_error!, style: const TextStyle(color: Color(0xFFC84C4C), fontWeight: FontWeight.w700))], const SizedBox(height: AppSpacing.xl), PrimaryButton(label: 'إضافة وإرسال دعوة محلية', icon: Icons.person_add_alt_1_outlined, onPressed: _submit, isLoading: _loading)]);
  }
}
