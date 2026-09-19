part of 'appointment_booking_screens.dart';

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  final _notesController = TextEditingController();
  int? _selectedDate;
  String? _selectedTime;
  String _appointmentType = 'زيارة في العيادة';
  String? _validationMessage;

  static const _dates = [
    AppointmentDate(day: 'الأحد', number: '٢٩', month: 'سبتمبر'),
    AppointmentDate(day: 'الاثنين', number: '٣٠', month: 'سبتمبر'),
    AppointmentDate(day: 'الثلاثاء', number: '١', month: 'أكتوبر'),
    AppointmentDate(day: 'الأربعاء', number: '٢', month: 'أكتوبر'),
    AppointmentDate(day: 'الخميس', number: '٣', month: 'أكتوبر'),
  ];

  static const _times = ['٠٩:٠٠ ص', '٠٩:٣٠ ص', '١٠:٠٠ ص', '١٠:٣٠ ص', '١١:٠٠ ص', '٠٤:٠٠ م', '٠٤:٣٠ م', '٠٥:٠٠ م'];
  static const _unavailableTimes = {'١٠:٠٠ ص', '٠٤:٣٠ م'};

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
              SizedBox(
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
                      unavailable: _unavailableTimes.contains(time),
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
              SizedBox(width: double.infinity, child: PrimaryButton(label: _selectedDate == null || _selectedTime == null ? 'اختر التاريخ والوقت' : 'تأكيد الموعد', icon: Icons.check_circle_outline, onPressed: _selectedDate == null || _selectedTime == null ? _validateSelection : _confirmAppointment)),
            ]),
          ),
        ),
      );

  void _validateSelection() => setState(() => _validationMessage = _selectedDate == null ? 'يرجى اختيار التاريخ' : 'يرجى اختيار الوقت');

  void _confirmAppointment() {
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => AppointmentConfirmationScreen(data: widget.bookingData, date: _dates[_selectedDate!], time: _selectedTime!)));
  }
}
