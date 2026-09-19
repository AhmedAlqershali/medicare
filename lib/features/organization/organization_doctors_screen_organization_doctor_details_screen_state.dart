part of 'organization_doctors_screen.dart';

class _OrganizationDoctorDetailsScreenState extends State<OrganizationDoctorDetailsScreen> {
  late OrganizationDoctor _doctor = widget.doctor;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('تفاصيل الطبيب'), leading: BackButton(onPressed: () => Navigator.of(context).pop(_doctor))),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppCard(
                child: Row(children: [
                  AppAvatar(initials: _doctor.initials, size: 72, backgroundColor: _doctor.avatarColor),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_doctor.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(_doctor.specialty, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    StatusBadge(label: _doctor.status, color: _doctor.status == 'نشط' ? AppColors.success : AppColors.muted),
                  ])),
                ]),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'معلومات الطبيب'),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Column(children: [
                  InfoRow(icon: Icons.local_hospital_outlined, label: 'العيادة', value: _doctor.clinic),
                  const Divider(height: AppSpacing.lg),
                  InfoRow(icon: Icons.phone_outlined, label: 'رقم الهاتف', value: _doctor.phone),
                  const Divider(height: AppSpacing.lg),
                  InfoRow(icon: Icons.email_outlined, label: 'البريد الإلكتروني', value: _doctor.email),
                ]),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'الجدول'),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                child: Row(children: [
                  const Icon(Icons.access_time_outlined, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(_doctor.scheduleSummary, style: Theme.of(context).textTheme.bodyLarge)),
                ]),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(width: double.infinity, child: PrimaryButton(label: 'تعديل بيانات الطبيب', icon: Icons.edit_outlined, onPressed: () async {
                final updated = await Navigator.of(context).push<OrganizationDoctor>(MaterialPageRoute<OrganizationDoctor>(builder: (_) => OrganizationDoctorFormScreen(doctor: _doctor)));
                if (updated != null && mounted) setState(() => _doctor = updated);
              })),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _toggleStatus, icon: const Icon(Icons.swap_horiz_rounded), label: const Text('تغيير الحالة'))),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => _showSchedule(), icon: const Icon(Icons.calendar_month_outlined), label: const Text('عرض الجدول'))),
            ]),
          ),
        ),
      );

  void _toggleStatus() {
    setState(() {
      final nextStatus = _doctor.status == 'نشط' ? 'غير متاح' : 'نشط';
      _doctor = _doctor.copyWith(status: nextStatus);
    });
  }

  void _showSchedule() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('الجدول: ${_doctor.scheduleSummary}')));
  }
}
