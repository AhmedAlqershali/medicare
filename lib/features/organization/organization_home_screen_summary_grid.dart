part of 'organization_home_screen.dart';

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid();

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final width = (constraints.maxWidth - AppSpacing.sm) / 2;
        return Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          _SummaryCard(width: width, label: 'عدد العيادات', value: '٦', icon: Icons.local_hospital_outlined, color: AppColors.sky),
          _SummaryCard(width: width, label: 'عدد الأطباء', value: '٣٢', icon: Icons.medical_information_outlined, color: AppColors.mint),
          _SummaryCard(width: width, label: 'عدد المرضى', value: '٨٤٠', icon: Icons.people_outline, color: AppColors.peach),
          _SummaryCard(width: width, label: 'مواعيد اليوم', value: '١٨', icon: Icons.calendar_month_outlined, color: AppColors.mint),
        ]);
      });
}
