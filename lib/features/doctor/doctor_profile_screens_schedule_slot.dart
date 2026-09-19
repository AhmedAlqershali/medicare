part of 'doctor_profile_screens.dart';

class _ScheduleSlot extends StatelessWidget {
  const _ScheduleSlot({required this.time, required this.booked});
  final String time;
  final bool booked;

  @override
  Widget build(BuildContext context) => Container(width: 106, padding: const EdgeInsets.symmetric(vertical: 13), alignment: Alignment.center, decoration: BoxDecoration(color: booked ? AppColors.primary : AppColors.mint, borderRadius: BorderRadius.circular(12), border: Border.all(color: booked ? AppColors.primary : AppColors.border)), child: Column(children: [Icon(booked ? Icons.event_available_outlined : Icons.add_circle_outline, color: booked ? Colors.white : AppColors.primary, size: 18), const SizedBox(height: 4), Text(time, style: TextStyle(color: booked ? Colors.white : AppColors.ink, fontSize: 12, fontWeight: FontWeight.w700))]));
}
