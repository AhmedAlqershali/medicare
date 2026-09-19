part of 'doctor_home_screen.dart';

class _DoctorDashboard extends StatelessWidget {
  const _DoctorDashboard({required this.onTabSelected});
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) => CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
            sliver: SliverList(delegate: SliverChildListDelegate([
              Row(children: [
                const AppAvatar(initials: 'أ ح', size: 52, backgroundColor: AppColors.sky),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('مرحباً د. أحمد', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 3),
                  Text('إليك ملخص يومك الطبي', style: Theme.of(context).textTheme.bodyMedium),
                ])),
                IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded), tooltip: 'الإشعارات'),
              ]),
              const SizedBox(height: AppSpacing.xl),
              Text('نظرة اليوم', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              const _OverviewGrid(),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(title: 'مواعيد اليوم', actionLabel: 'عرض الكل', onAction: () => onTabSelected(1)),
              const SizedBox(height: AppSpacing.sm),
              for (final appointment in doctorAppointments.take(3)) ...[
                _DashboardAppointmentCard(appointment: appointment, onDetails: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => DoctorAppointmentDetailsScreen(appointment: appointment)))),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.md),
              Text('إجراءات سريعة', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              _QuickActions(onTabSelected: onTabSelected),
            ])),
          ),
        ],
      );
}
