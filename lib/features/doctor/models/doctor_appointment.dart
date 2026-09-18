import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

enum DoctorAppointmentFilter { today, upcoming, completed, cancelled }

class DoctorAppointment {
  const DoctorAppointment({required this.patientName, required this.patientInitials, required this.age, required this.gender, required this.date, required this.time, required this.type, required this.status, required this.notes, required this.avatarColor});
  final String patientName;
  final String patientInitials;
  final String age;
  final String gender;
  final String date;
  final String time;
  final String type;
  final DoctorAppointmentFilter status;
  final String notes;
  final Color avatarColor;

  String get statusLabel => switch (status) { DoctorAppointmentFilter.today => 'اليوم', DoctorAppointmentFilter.upcoming => 'قادم', DoctorAppointmentFilter.completed => 'مكتمل', DoctorAppointmentFilter.cancelled => 'ملغي' };
  Color get statusColor => switch (status) { DoctorAppointmentFilter.today => AppColors.primary, DoctorAppointmentFilter.upcoming => AppColors.primary, DoctorAppointmentFilter.completed => AppColors.success, DoctorAppointmentFilter.cancelled => AppColors.muted };
  DoctorAppointment copyWith({DoctorAppointmentFilter? status}) => DoctorAppointment(patientName: patientName, patientInitials: patientInitials, age: age, gender: gender, date: date, time: time, type: type, status: status ?? this.status, notes: notes, avatarColor: avatarColor);
}
