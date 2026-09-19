part of 'patient_profile_screens.dart';

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  var _patient = mockPatientProfile;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('الملف الشخصي')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _ProfileHeader(
                patient: _patient,
                onEdit: () async {
                  final updated = await Navigator.of(context).push<PatientProfile>(MaterialPageRoute(builder: (_) => EditPatientProfileScreen(patient: _patient)));
                  if (updated != null && mounted) setState(() => _patient = updated);
                },
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'المعلومات الشخصية'),
              const SizedBox(height: AppSpacing.sm),
              _InfoCard(icon: Icons.badge_outlined, label: 'الاسم الكامل', value: _patient.name),
              _InfoCard(icon: Icons.phone_outlined, label: 'رقم الهاتف', value: _patient.phone),
              _InfoCard(icon: Icons.email_outlined, label: 'البريد الإلكتروني', value: _patient.email),
              _InfoCard(icon: Icons.cake_outlined, label: 'تاريخ الميلاد', value: _patient.birthDate),
              _InfoCard(icon: Icons.person_outline, label: 'الجنس', value: _patient.gender),
              const SizedBox(height: AppSpacing.md),
              _NavigationTile(icon: Icons.settings_outlined, title: 'الإعدادات', onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PatientSettingsScreen()))),
            ]),
          ),
        ),
      );
}
