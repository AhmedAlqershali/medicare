part of 'patient_home_screen.dart';

class _ClinicsSection extends StatelessWidget {
  const _ClinicsSection();

  @override
  Widget build(BuildContext context) => Column(children: const [
        ClinicCard(name: 'عيادات النخبة', location: 'حي العليا • رعاية متعددة التخصصات'),
        SizedBox(height: AppSpacing.sm),
        ClinicCard(name: 'مركز الحياة الطبي', location: 'حي المروج • طب الأطفال والأسرة'),
      ]);
}
