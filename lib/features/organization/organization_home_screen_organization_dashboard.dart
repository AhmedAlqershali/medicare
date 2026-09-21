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
  int _patientsCount = 0;
  int _appointmentsCount = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final organizationId = FirebaseAuthRepository.instance.session.organizationId;
    if (organizationId == null || organizationId.isEmpty) {
      if (mounted) setState(() => _error = 'لا توجد مؤسسة نشطة مرتبطة بالجلسة الحالية.');
      return;
    }
    try {
      final results = await Future.wait([
        const OrganizationClinicsRepositoryImpl().getOrganizationClinics(),
        const OrganizationDoctorsRepositoryImpl().getOrganizationDoctors(),
        FirestorePatientRepository.instance.fetchPatientsForOrganization(organizationId),
        FirestoreAppointmentRepository.instance.fetchAppointmentsForOrganization(organizationId),
      ]);
      final clinics = results[0] as List<OrganizationClinic>;
      final doctors = results[1] as List<OrganizationDoctor>;
      final patients = results[2] as List;
      final appointments = results[3] as List;
      if (!mounted) return;
      setState(() {
        _clinics = clinics;
        _doctors = doctors;
        _patientsCount = patients.length;
        _appointmentsCount = appointments.length;
      });
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
            sliver: SliverList(delegate: SliverChildListDelegate([
              Row(children: [
                AppAvatar(initials: _initials, size: 52, backgroundColor: AppColors.sky),
                SizedBox(width: AppSpacing.sm),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('مرحباً بك في Medicare', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  SizedBox(height: 3),
                  Text(_organizationName, style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.45)),
                ])),
              ]),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.md),
                ErrorState(message: _error!, onRetry: _loadDashboardData),
              ],
              const SizedBox(height: AppSpacing.xl),
              Text('ملخص الإدارة', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              _SummaryGrid(clinics: _clinics.length, doctors: _doctors.length, patients: _patientsCount, appointments: _appointmentsCount),
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

  String get _organizationName => FirebaseAuthRepository.instance.session.currentUser?.name ?? 'المؤسسة الطبية';

  String get _initials {
    final parts = _organizationName.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.isEmpty) return 'م';
    if (parts.length == 1) return parts.first.substring(0, 1);
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}';
  }
}
