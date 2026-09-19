part of 'organization_home_screen.dart';

class _OrganizationDashboard extends StatelessWidget {
  const _OrganizationDashboard({required this.onTabSelected});
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) => CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
            sliver: SliverList(delegate: SliverChildListDelegate([
              const Row(children: [
                AppAvatar(initials: 'م م', size: 52, backgroundColor: AppColors.sky),
                SizedBox(width: AppSpacing.sm),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('مرحباً بك في Medicare', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  SizedBox(height: 3),
                  Text('مؤسسة Medicare الطبية', style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.45)),
                ])),
              ]),
              const SizedBox(height: AppSpacing.xl),
              Text('ملخص الإدارة', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              const _SummaryGrid(),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(title: 'العيادات', actionLabel: 'عرض جميع العيادات', onAction: () => onTabSelected(1)),
              const SizedBox(height: AppSpacing.sm),
              for (final clinic in mockOrganizationClinics.take(2)) ...[
                _ClinicPreviewCard(clinic: clinic, onTap: () => onTabSelected(1)),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(title: 'الأطباء', actionLabel: 'عرض جميع الأطباء', onAction: () => onTabSelected(2)),
              const SizedBox(height: AppSpacing.sm),
              for (final doctor in mockOrganizationDoctors.take(2)) ...[
                _DoctorPreviewCard(doctor: doctor, onTap: () => onTabSelected(2)),
                const SizedBox(height: AppSpacing.sm),
              ],
            ])),
          ),
        ],
      );
}
