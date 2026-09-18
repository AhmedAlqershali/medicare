import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/medicare_widgets.dart';
import 'appointments_screens.dart';

class AppointmentBookingData {
  const AppointmentBookingData({required this.doctorName, required this.doctorInitials, required this.specialty, required this.clinicName, required this.location, required this.avatarColor});

  final String doctorName;
  final String doctorInitials;
  final String specialty;
  final String clinicName;
  final String location;
  final Color avatarColor;
}

class AppointmentBookingScreen extends StatefulWidget {
  const AppointmentBookingScreen({super.key, required this.bookingData});

  final AppointmentBookingData bookingData;

  @override
  State<AppointmentBookingScreen> createState() => _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  final _notesController = TextEditingController();
  int? _selectedDate;
  String? _selectedTime;
  String _appointmentType = 'زيارة في العيادة';
  String? _validationMessage;

  static const _dates = [
    _AppointmentDate(day: 'الأحد', number: '٢٩', month: 'سبتمبر'),
    _AppointmentDate(day: 'الاثنين', number: '٣٠', month: 'سبتمبر'),
    _AppointmentDate(day: 'الثلاثاء', number: '١', month: 'أكتوبر'),
    _AppointmentDate(day: 'الأربعاء', number: '٢', month: 'أكتوبر'),
    _AppointmentDate(day: 'الخميس', number: '٣', month: 'أكتوبر'),
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
                  separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
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

class AppointmentConfirmationScreen extends StatelessWidget {
  const AppointmentConfirmationScreen({super.key, required this.data, required this.date, required this.time});

  final AppointmentBookingData data;
  final _AppointmentDate date;
  final String time;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('تأكيد الموعد'), leading: const BackButton()),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.xl),
            child: Column(children: [
              Container(width: 88, height: 88, decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(28)), child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 54)),
              const SizedBox(height: AppSpacing.lg),
              Text('تم تأكيد الموعد', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xs),
              Text('تم تسجيل تفاصيل موعدك بشكل تجريبي.', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xl),
              AppCard(child: Column(children: [
                _ConfirmationRow(icon: Icons.person_outline, title: 'الطبيب', value: data.doctorName),
                const Divider(height: AppSpacing.lg),
                _ConfirmationRow(icon: Icons.local_hospital_outlined, title: 'العيادة', value: data.clinicName),
                const Divider(height: AppSpacing.lg),
                _ConfirmationRow(icon: Icons.calendar_month_outlined, title: 'التاريخ', value: '${date.day} ${date.number} ${date.month}'),
                const Divider(height: AppSpacing.lg),
                _ConfirmationRow(icon: Icons.schedule_outlined, title: 'الوقت', value: time),
              ])),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(width: double.infinity, child: PrimaryButton(label: 'عرض مواعيدي', icon: Icons.calendar_month_outlined, onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<void>(builder: (_) => const AppointmentsScreen()), (route) => route.isFirst)),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(width: double.infinity, child: OutlinedButton(onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst), child: const Text('العودة للرئيسية'))),
            ]),
          ),
        ),
      );
}

class _DoctorSummary extends StatelessWidget {
  const _DoctorSummary({required this.data});
  final AppointmentBookingData data;

  @override
  Widget build(BuildContext context) => AppCard(child: Row(children: [AppAvatar(initials: data.doctorInitials, size: 62, backgroundColor: data.avatarColor), const SizedBox(width: AppSpacing.md), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(data.doctorName, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 17)), const SizedBox(height: 4), Text(data.specialty, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.w600)), const SizedBox(height: 5), Row(children: [const Icon(Icons.local_hospital_outlined, color: AppColors.muted, size: 15), const SizedBox(width: 4), Expanded(child: Text(data.clinicName, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium))]), const SizedBox(height: 3), Row(children: [const Icon(Icons.location_on_outlined, color: AppColors.muted, size: 15), const SizedBox(width: 4), Expanded(child: Text(data.location, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium))])]))]));
}

class _DateOption extends StatelessWidget {
  const _DateOption({required this.date, required this.selected, required this.onTap});
  final _AppointmentDate date;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14), child: Container(width: 82, padding: const EdgeInsets.symmetric(vertical: 9), decoration: BoxDecoration(color: selected ? AppColors.primary : AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: selected ? AppColors.primary : AppColors.border)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(date.day, style: TextStyle(color: selected ? Colors.white : AppColors.muted, fontSize: 11, fontWeight: FontWeight.w600)), const SizedBox(height: 2), Text(date.number, style: TextStyle(color: selected ? Colors.white : AppColors.ink, fontSize: 20, fontWeight: FontWeight.w800)), Text(date.month, style: TextStyle(color: selected ? Colors.white : AppColors.muted, fontSize: 11, fontWeight: FontWeight.w600))])));
}

class _TimeOption extends StatelessWidget {
  const _TimeOption({required this.label, required this.selected, required this.unavailable, required this.onTap});
  final String label;
  final bool selected;
  final bool unavailable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(onTap: unavailable ? null : onTap, borderRadius: BorderRadius.circular(11), child: Container(width: 92, alignment: Alignment.center, padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: unavailable ? AppColors.canvas : selected ? AppColors.mint : AppColors.surface, borderRadius: BorderRadius.circular(11), border: Border.all(color: unavailable ? AppColors.border : selected ? AppColors.primary : AppColors.border)), child: Text(label, style: TextStyle(color: unavailable ? AppColors.muted : selected ? AppColors.primaryDark : AppColors.ink, fontSize: 12, fontWeight: FontWeight.w700, decoration: unavailable ? TextDecoration.lineThrough : null))));
}

class _AppointmentTypeOption extends StatelessWidget {
  const _AppointmentTypeOption({required this.label, required this.icon, required this.selected, required this.onTap});
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(onTap: onTap, borderRadius: BorderRadius.circular(14), child: Container(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.md), decoration: BoxDecoration(color: selected ? AppColors.mint : AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: selected ? AppColors.primary : AppColors.border)), child: Row(children: [Icon(icon, color: selected ? AppColors.primary : AppColors.muted, size: 21), const SizedBox(width: AppSpacing.xs), Expanded(child: Text(label, style: TextStyle(color: selected ? AppColors.primaryDark : AppColors.ink, fontSize: 12, fontWeight: FontWeight.w700))), Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off, color: selected ? AppColors.primary : AppColors.muted, size: 19)])));
}

class _AppointmentSummary extends StatelessWidget {
  const _AppointmentSummary({required this.data, required this.date, required this.time, required this.type, required this.notes});
  final AppointmentBookingData data;
  final _AppointmentDate? date;
  final String? time;
  final String type;
  final String notes;

  @override
  Widget build(BuildContext context) => AppCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ملخص الموعد', style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: AppSpacing.md), _SummaryLine(label: 'الطبيب', value: data.doctorName), _SummaryLine(label: 'التخصص', value: data.specialty), _SummaryLine(label: 'العيادة', value: data.clinicName), _SummaryLine(label: 'التاريخ', value: date == null ? 'لم يتم الاختيار' : '${date!.day} ${date!.number} ${date!.month}'), _SummaryLine(label: 'الوقت', value: time ?? 'لم يتم الاختيار'), _SummaryLine(label: 'نوع الموعد', value: type), if (notes.trim().isNotEmpty) _SummaryLine(label: 'الملاحظات', value: notes.trim())]));
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: AppSpacing.sm), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [SizedBox(width: 78, child: Text(label, style: Theme.of(context).textTheme.bodyMedium)), Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w700)))]);
}

class _ConfirmationRow extends StatelessWidget {
  const _ConfirmationRow({required this.icon, required this.title, required this.value});
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Row(children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: AppColors.mint, borderRadius: BorderRadius.circular(11)), child: Icon(icon, color: AppColors.primary, size: 19)), const SizedBox(width: AppSpacing.sm), Text('$title: ', style: Theme.of(context).textTheme.bodyMedium), Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.ink, fontWeight: FontWeight.w700)))]);
}

class _AppointmentDate {
  const _AppointmentDate({required this.day, required this.number, required this.month});
  final String day;
  final String number;
  final String month;
}