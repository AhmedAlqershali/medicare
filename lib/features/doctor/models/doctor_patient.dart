import 'package:flutter/material.dart';

class DoctorPatient {
  const DoctorPatient({required this.name, required this.initials, required this.age, required this.gender, required this.lastAppointment, required this.status, required this.avatarColor, required this.notes});
  final String name;
  final String initials;
  final String age;
  final String gender;
  final String lastAppointment;
  final String status;
  final Color avatarColor;
  final String notes;
}
