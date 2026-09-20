part of 'organization_home_screen.dart';

class _OrganizationDashboard extends StatefulWidget {
  const _OrganizationDashboard({required this.onTabSelected});
  final ValueChanged<int> onTabSelected;

  @override
  State<_OrganizationDashboard> createState() => _OrganizationDashboardState();
}

class _OrganizationDashboardState extends State<_OrganizationDashboard> {
  List<OrganizationClinicEntity> _clinics = const [];
  List<OrganizationDoctorEntity> _doctors = const [];

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
                _ClinicPreviewCard(clinic: OrganizationClinic(
                  id: clinic.id,
                  name: clinic.name,
                  location: clinic.location,
                  phone: clinic.phone,
                  description: clinic.description,
                  status: clinic.status,
                  doctorsCount: clinic.doctorsCount,
                  departmentsCount: clinic.departmentsCount,
                  patientsCount: clinic.patientsCount,
                  icon: IconData(clinic.iconCodePoint, fontFamily: 'MaterialIcons'),
                  color: Color(clinic.colorValue),
                  departments: List<String>.from(clinic.departments),
                ), onTap: () => widget.onTabSelected(1)),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(title: 'الأطباء', actionLabel: 'عرض جميع الأطباء', onAction: () => widget.onTabSelected(2)),
              const SizedBox(height: AppSpacing.sm),
              for (final doctor in _doctors.take(2)) ...[
                _DoctorPreviewCard(doctor: OrganizationDoctor(
                  id: doctor.id,
                  name: doctor.name,
                  initials: doctor.initials,
                  specialty: doctor.specialty,
                  clinic: doctor.clinic,
                  phone: doctor.phone,
                  email: doctor.email,
                  status: doctor.status,
                  avatarColor: Color(doctor.avatarColorValue),
                  scheduleSummary: doctor.scheduleSummary,
                ), onTap: () => widget.onTabSelected(2)),
                const SizedBox(height: AppSpacing.sm),
              ],
            ])),
          ),
        ],
      );
}
