part of 'organization_home_screen.dart';

class _OrganizationDashboard extends StatefulWidget {
  const _OrganizationDashboard({required this.onTabSelected});
  final ValueChanged<int> onTabSelected;

  @override
  State<_OrganizationDashboard> createState() => _OrganizationDashboardState();
}

class _OrganizationDashboardState extends State<_OrganizationDashboard> {
  List<OrganizationClinic> _clinics = const [];
  List<OrganizationDoctor> _doctors = const [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final clinics = await const OrganizationClinicsRepositoryImpl().getOrganizationClinics();
    final doctors = await const OrganizationDoctorsRepositoryImpl().getOrganizationDoctors();
    if (!mounted) return;
    setState(() {
      _clinics = clinics;
      _doctors = doctors;
    });
  }

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
              SectionHeader(title: 'العيادات', actionLabel: 'عرض جميع العيادات', onAction: () => widget.onTabSelected(1)),
              const SizedBox(height: AppSpacing.sm),
              for (final clinic in _clinics.take(2)) ...[
                _ClinicPreviewCard(clinic: clinic, onTap: () => widget.onTabSelected(1)),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(title: 'الأطباء', actionLabel: 'عرض جميع الأطباء', onAction: () => widget.onTabSelected(2)),
              const SizedBox(height: AppSpacing.sm),
              for (final doctor in _doctors.take(2)) ...[
                _DoctorPreviewCard(doctor: doctor, onTap: () => widget.onTabSelected(2)),
                const SizedBox(height: AppSpacing.sm),
              ],
            ])),
          ),
        ],
      );
}
