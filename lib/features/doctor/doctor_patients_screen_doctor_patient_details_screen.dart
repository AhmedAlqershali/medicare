part of 'doctor_patients_screen.dart';

class DoctorPatientDetailsScreen extends StatelessWidget {
  const DoctorPatientDetailsScreen({super.key, required this.patient});
  final DoctorPatient patient;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('ملف المريض')),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  child: Row(
                    children: [
                      AppAvatar(initials: patient.initials, size: 72, backgroundColor: patient.avatarColor),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(patient.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)),
                            const SizedBox(height: 5),
                            Text('${patient.age}  •  ${patient.gender}', style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: AppSpacing.sm),
                            StatusBadge(label: patient.status, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(title: 'المعلومات الأساسية'),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: Column(
                    children: [
                      _InfoRow(label: 'العمر', value: patient.age, icon: Icons.cake_outlined),
                      const Divider(height: AppSpacing.lg),
                      _InfoRow(label: 'الجنس', value: patient.gender, icon: Icons.person_outline),
                      const Divider(height: AppSpacing.lg),
                      _InfoRow(label: 'آخر موعد', value: patient.lastAppointment, icon: Icons.calendar_month_outlined),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(title: 'المواعيد السابقة'),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: Column(
                    children: [
                      _HistoryRow(date: patient.lastAppointment, title: 'زيارة متابعة', status: 'مكتمل'),
                      const Divider(height: AppSpacing.lg),
                      const _HistoryRow(date: '٢٨ أغسطس ٢٠٢٦', title: 'استشارة', status: 'مكتمل'),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const SectionHeader(title: 'الملاحظات'),
                const SizedBox(height: AppSpacing.sm),
                AppCard(child: Text(patient.notes, style: Theme.of(context).textTheme.bodyLarge)),
              ],
            ),
          ),
        ),
      );
}
