part of 'organization_doctors_screen.dart';

class _OrganizationDoctorFormScreenState extends State<OrganizationDoctorFormScreen> {
  late final TextEditingController _nameController = TextEditingController(text: widget.doctor.name.replaceFirst('د. ', ''));
  late final TextEditingController _specialtyController = TextEditingController(text: widget.doctor.specialty);
  late final TextEditingController _clinicController = TextEditingController(text: widget.doctor.clinic);
  late final TextEditingController _phoneController = TextEditingController(text: widget.doctor.phone);
  late final TextEditingController _emailController = TextEditingController(text: widget.doctor.email);

  @override
  void dispose() {
    _nameController.dispose();
    _specialtyController.dispose();
    _clinicController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    final updated = widget.doctor.copyWith(
      name: 'د. ${_nameController.text.trim()}',
      specialty: _specialtyController.text.trim(),
      clinic: _clinicController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
    );
    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('تعديل بيانات الطبيب')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(children: [
              CustomTextField(label: 'اسم الطبيب', prefixIcon: Icons.badge_outlined, controller: _nameController),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'التخصص', prefixIcon: Icons.medical_information_outlined, controller: _specialtyController),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'العيادة', prefixIcon: Icons.local_hospital_outlined, controller: _clinicController),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'رقم الهاتف', prefixIcon: Icons.phone_outlined, controller: _phoneController, keyboardType: TextInputType.phone),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(label: 'البريد الإلكتروني', prefixIcon: Icons.email_outlined, controller: _emailController, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(width: double.infinity, child: PrimaryButton(label: 'حفظ', icon: Icons.check_rounded, onPressed: _save)),
            ]),
          ),
        ),
      );
}
