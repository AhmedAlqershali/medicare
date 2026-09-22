part of 'appointment_booking_screens.dart';

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  final _notesController = TextEditingController();
  int? _selectedDate;
  String? _selectedTime;
  String _appointmentType = 'زيارة في العيادة';
  String? _validationMessage;
  bool _loading = false;
  Map<String, List<String>> _availableAvailability = const {};

  @override
  void initState() {
    super.initState();
    _availableAvailability = widget.bookingData.availability;
    _loadBookedSlots();
  }

  List<AppointmentDate> get _dates => _availableAvailability.keys.map(AppointmentDate.fromFirebase).toList();
  List<String> get _times => _dates.isEmpty ? const [] : _availableAvailability[_dates[_selectedDate ?? 0].label] ?? const [];

  Future<void> _loadBookedSlots() async {
    final session = FirebaseAuthRepository.instance.session;
    final organizationId = session.organizationId;
    if (organizationId == null || organizationId.isEmpty || widget.bookingData.doctorId.isEmpty) return;
    try {
      final appointments = await FirestoreAppointmentRepository.instance.fetchAppointmentsForDoctor(organizationId: organizationId, doctorId: widget.bookingData.doctorId);
      final booked = appointments.map((appointment) => '${appointment['date'] ?? ''}|${appointment['time'] ?? ''}').toSet();
      final available = <String, List<String>>{};
      for (final entry in _availableAvailability.entries) {
        final slots = entry.value.where((time) => !booked.contains('${entry.key}|$time')).toList();
        if (slots.isNotEmpty) available[entry.key] = slots;
      }
      if (mounted) setState(() {
        _availableAvailability = available;
        if (_selectedDate != null && _selectedDate! >= _dates.length) _selectedDate = null;
        _selectedTime = null;
      });
    } catch (error) {
      if (mounted) setState(() => _validationMessage = error.toString());
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('حجز موعد'), leading: const BackButton()),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xl),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _DoctorSummary(data: widget.bookingData),
              const SizedBox(height: AppSpacing.xl),
              Text('اختر التاريخ', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              if (_dates.isEmpty) const EmptyState(title: 'لا توجد مواعيد متاحة', message: 'لم يتم نشر أوقات توافر لهذا الطبيب بعد.') else SizedBox(
                height: 86,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _dates.length,
                  separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) => _DateOption(
                    date: _dates[index],
                    selected: index == _selectedDate,
                    onTap: () => setState(() {
                      _selectedDate = index;
                      _validationMessage = null;
                    }),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('اختر الوقت', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final time in _times)
                    _TimeOption(
                      label: time,
                      selected: time == _selectedTime,
                      unavailable: false,
                      onTap: () => setState(() {
                        _selectedTime = time;
                        _validationMessage = null;
                      }),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('نوع الموعد', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Row(children: [
                Expanded(child: _AppointmentTypeOption(label: 'زيارة في العيادة', icon: Icons.local_hospital_outlined, selected: _appointmentType == 'زيارة في العيادة', onTap: () => setState(() => _appointmentType = 'زيارة في العيادة'))),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: _AppointmentTypeOption(label: 'استشارة', icon: Icons.video_call_outlined, selected: _appointmentType == 'استشارة', onTap: () => setState(() => _appointmentType = 'استشارة'))),
              ]),
              const SizedBox(height: AppSpacing.xl),
              Text('ملاحظات إضافية', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              CustomTextField(label: 'ملاحظات إضافية', hintText: 'اكتب أي ملاحظات تريد إضافتها...', controller: _notesController, keyboardType: TextInputType.multiline, textInputAction: TextInputAction.newline, onChanged: (_) => setState(() {})),
              const SizedBox(height: AppSpacing.xl),
              _AppointmentSummary(data: widget.bookingData, date: _selectedDate == null ? null : _dates[_selectedDate!], time: _selectedTime, type: _appointmentType, notes: _notesController.text),
              if (_validationMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(_validationMessage!, style: const TextStyle(color: Color(0xFFC84C4C), fontSize: 13, fontWeight: FontWeight.w700)),
              ],
              const SizedBox(height: AppSpacing.lg),
              SizedBox(width: double.infinity, child: PrimaryButton(label: _selectedDate == null || _selectedTime == null ? 'اختر التاريخ والوقت' : 'تأكيد الموعد', icon: Icons.check_circle_outline, onPressed: _selectedDate == null || _selectedTime == null ? _validateSelection : _confirmAppointment, isLoading: _loading)),
            ]),
          ),
        ),
      );

  void _validateSelection() => setState(() => _validationMessage = _selectedDate == null ? 'يرجى اختيار التاريخ' : 'يرجى اختيار الوقت');

  Future<void> _confirmAppointment() async {
    final session = FirebaseAuthRepository.instance.session;
    final organizationId = session.organizationId;
    final patientId = session.patientId;
    if (organizationId == null || patientId == null || widget.bookingData.doctorId.isEmpty) {
      setState(() => _validationMessage = 'تعذر تحديد بيانات الحساب أو الطبيب. أعد تسجيل الدخول وحاول مرة أخرى.');
      return;
    }
    setState(() {
      _loading = true;
      _validationMessage = null;
    });
    try {
      final appointmentId = 'appointment-${DateTime.now().microsecondsSinceEpoch}';
      await FirestoreAppointmentRepository.instance.createAppointment(
        organizationId: organizationId,
        appointment: {
          'id': appointmentId,
          'patientId': patientId,
          'patientUid': FirebaseAuth.instance.currentUser?.uid,
          'doctorId': widget.bookingData.doctorId,
          'doctorName': widget.bookingData.doctorName,
          'doctorInitials': widget.bookingData.doctorInitials,
          'specialty': widget.bookingData.specialty,
          'clinicName': widget.bookingData.clinicName,
          'location': widget.bookingData.location,
          'date': _dates[_selectedDate!].label,
          'time': _selectedTime,
          'type': _appointmentType,
          'status': 'upcoming',
          'notes': _notesController.text.trim(),
        },
      );
      if (!mounted) return;
      setState(() => _loading = false);
      Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => AppointmentConfirmationScreen(data: widget.bookingData, date: _dates[_selectedDate!], time: _selectedTime!)));
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _validationMessage = error.toString();
      });
    }
  }
}
