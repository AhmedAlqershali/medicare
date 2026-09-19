part of 'patient_home_screen.dart';

class _DoctorsSection extends StatelessWidget {
  const _DoctorsSection();

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 188,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: const [
            _DoctorCard(initials: 'ل س', name: 'د. ليان السالم', specialty: 'طب الأطفال', clinic: 'مركز الحياة', color: AppColors.peach),
            SizedBox(width: AppSpacing.sm),
            _DoctorCard(initials: 'ر ح', name: 'د. ريم الحربي', specialty: 'طب الأسرة', clinic: 'عيادات النخبة', color: AppColors.sky),
            SizedBox(width: AppSpacing.sm),
            _DoctorCard(initials: 'ن ع', name: 'د. ناصر العتيبي', specialty: 'طب العيون', clinic: 'مركز النور', color: AppColors.mint),
          ],
        ),
      );
}
