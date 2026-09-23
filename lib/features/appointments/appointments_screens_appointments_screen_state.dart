part of 'appointments_screens.dart';

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  AppointmentStatus _selectedStatus = AppointmentStatus.upcoming;
  late List<AppointmentData> _appointments = const [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    List<AppointmentEntity> appointments;
    try {
      appointments = await const AppointmentsRepositoryImpl().getAppointments();
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
      return;
    }
    if (!mounted) return;
    setState(() {
      _appointments = appointments.map(_toAppointmentData).toList();
    });
  }

    List<AppointmentData> get _visibleAppointments => _appointments.where((appointment) => appointment.status == _selectedStatus).toList();

    AppointmentData _toAppointmentData(AppointmentEntity entity) => AppointmentData(
      id: entity.id,
      doctorId: entity.doctorId,
      clinicId: entity.clinicId,
        doctorName: entity.doctorName,
        doctorInitials: entity.doctorInitials,
        specialty: entity.specialty,
        clinicName: entity.clinicName,
        location: entity.location,
        date: entity.date,
        time: entity.time,
        type: entity.type,
        status: _toUiStatus(entity.status),
        avatarColor: Color(entity.avatarColorValue),
        notes: entity.notes,
      );

  AppointmentStatus _toUiStatus(AppointmentEntityStatus status) => switch (status) {
        AppointmentEntityStatus.upcoming => AppointmentStatus.upcoming,
        AppointmentEntityStatus.completed => AppointmentStatus.completed,
        AppointmentEntityStatus.cancelled => AppointmentStatus.cancelled,
      };

  AppointmentBookingData _bookingData(AppointmentData appointment) => AppointmentBookingData(
      doctorId: appointment.doctorId,
      clinicId: appointment.clinicId,
        doctorName: appointment.doctorName,
        doctorInitials: appointment.doctorInitials,
        specialty: appointment.specialty,
        clinicName: appointment.clinicName,
        location: appointment.location,
        avatarColor: appointment.avatarColor,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('مواعيدي'), leading: const BackButton()),
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.md),
                sliver: SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('تابع مواعيدك الطبية بسهولة', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: AppSpacing.lg),
                  _AppointmentTabs(selected: _selectedStatus, onChanged: (status) => setState(() => _selectedStatus = status)),
                ])),
              ),
              if (_visibleAppointments.isEmpty)
                SliverFillRemaining(hasScrollBody: false, child: _EmptyAppointments(status: _selectedStatus, onBook: _openDoctors))
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
                  sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                    final appointment = _visibleAppointments[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: AppointmentCard(
                        appointment: appointment,
                        onDetails: () => _openDetails(appointment),
                        onRebook: appointment.status == AppointmentStatus.completed ? () => _rebook(appointment) : null,
                      ),
                    );
                  }, childCount: _visibleAppointments.length)),
                ),
            ],
          ),
        ),
      );

  void _openDetails(AppointmentData appointment) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AppointmentDetailsScreen(appointment: appointment, onCancelled: () => _cancelAppointment(appointment))));
  }

  Future<void> _cancelAppointment(AppointmentData appointment) async {
    final organizationId = FirebaseAuthRepository.instance.session.organizationId;
    if (organizationId == null || appointment.id.isEmpty) return;
    try {
      await FirestoreAppointmentRepository.instance.saveAppointment(
        organizationId: organizationId,
        appointment: {'id': appointment.id, 'status': AppointmentStatus.cancelled.name},
      );
    } catch (error) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
      return;
    }
    if (!mounted) return;
    setState(() {
      final index = _appointments.indexOf(appointment);
      if (index != -1) _appointments[index] = appointment.copyWith(status: AppointmentStatus.cancelled);
    });
  }

  void _rebook(AppointmentData appointment) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AppointmentBookingScreen(bookingData: _bookingData(appointment))));
  }

  void _openDoctors() => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const DoctorsListScreen()));
}
