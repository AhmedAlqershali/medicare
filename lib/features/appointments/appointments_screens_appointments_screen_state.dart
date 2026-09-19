part of 'appointments_screens.dart';

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  AppointmentStatus _selectedStatus = AppointmentStatus.upcoming;
  final List<MockAppointment> _appointments = List.of(mockAppointments);

  List<MockAppointment> get _visibleAppointments => _appointments.where((appointment) => appointment.status == _selectedStatus).toList();

  AppointmentBookingData _bookingData(MockAppointment appointment) => AppointmentBookingData(
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

  void _openDetails(MockAppointment appointment) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AppointmentDetailsScreen(appointment: appointment, onCancelled: () => _cancelAppointment(appointment))));
  }

  void _cancelAppointment(MockAppointment appointment) {
    setState(() {
      final index = _appointments.indexOf(appointment);
      if (index != -1) _appointments[index] = appointment.copyWith(status: AppointmentStatus.cancelled);
    });
  }

  void _rebook(MockAppointment appointment) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AppointmentBookingScreen(bookingData: _bookingData(appointment))));
  }

  void _openDoctors() => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const DoctorsListScreen()));
}
