part of 'doctor_home_screen.dart';

class _OverviewGrid extends StatelessWidget {
  const _OverviewGrid();

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final width = (constraints.maxWidth - AppSpacing.sm) / 2;
        return Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          _OverviewCard(width: width, label: 'مواعيد اليوم', value: '٨', icon: Icons.calendar_today_outlined, color: AppColors.sky),
          _OverviewCard(width: width, label: 'المرضى', value: '١٢٤', icon: Icons.people_outline, color: AppColors.mint),
          _OverviewCard(width: width, label: 'المواعيد القادمة', value: '١٦', icon: Icons.upcoming_outlined, color: AppColors.peach),
          _OverviewCard(width: width, label: 'المواعيد المكتملة', value: '٣٦', icon: Icons.task_alt_outlined, color: AppColors.mint),
        ]);
      });
}
