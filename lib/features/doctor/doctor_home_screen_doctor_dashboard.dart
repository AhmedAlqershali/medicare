part of 'doctor_home_screen.dart';

class _DoctorDashboard extends StatefulWidget {
  const _DoctorDashboard({required this.onTabSelected});
  final ValueChanged<int> onTabSelected;

  @override
  State<_DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<_DoctorDashboard> {
  List<DoctorAppointment> _appointments = const [];
  int _patientsCount = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      final items = await DoctorAppointmentsRepositoryImpl().getDoctorAppointments();
      final doctorId = FirebaseAuthRepository.instance.session.doctorId;
      final patients = doctorId == null ? const [] : await FirestorePatientRepository.instance.fetchPatientsForDoctor(doctorId);
      if (!mounted) return;
      setState(() {
        _appointments = items;
        _patientsCount = patients.length;
      });
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
      return;
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
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('مرحباً، ${FirebaseAuthRepository.instance.session.currentUser?.name ?? 'الطبيب'}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 3),
                  Text('إليك ملخص يومك الطبي', style: Theme.of(context).textTheme.bodyMedium),
                ])),
                IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لا توجد إشعارات جديدة.'))), icon: const Icon(Icons.notifications_none_rounded), tooltip: 'الإشعارات'),
              ]),
              const SizedBox(height: AppSpacing.xl),
              Text('نظرة اليوم', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              if (_error != null) ErrorState(message: _error!, onRetry: _loadAppointments),
              _OverviewGrid(appointments: _appointments.length, patients: _patientsCount),
              const SizedBox(height: AppSpacing.xl),
              SectionHeader(title: 'مواعيد اليوم', actionLabel: 'عرض الكل', onAction: () => widget.onTabSelected(1)),
              const SizedBox(height: AppSpacing.sm),
              for (final appointment in _appointments.take(3)) ...[
                _DashboardAppointmentCard(appointment: appointment, onDetails: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => DoctorAppointmentDetailsScreen(appointment: appointment)))),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.md),
              Text('إجراءات سريعة', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              _QuickActions(onTabSelected: widget.onTabSelected),
            ])),
          ),
        ],
      );

  String get _initials {
    final name = FirebaseAuthRepository.instance.session.currentUser?.name ?? 'ط';
    final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    return parts.length > 1 ? '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}' : parts.first.substring(0, 1);
  }
}
