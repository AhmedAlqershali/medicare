import 'package:flutter/material.dart';

enum AppointmentStatus { upcoming, completed, cancelled }

class MockAppointment {
  const MockAppointment({required this.doctorName, required this.doctorInitials, required this.specialty, required this.clinicName, required this.location, required this.date, required this.time, required this.type, required this.status, required this.avatarColor, this.notes});

  final String doctorName;
  final String doctorInitials;
  final String specialty;
  final String clinicName;
  final String location;
  final String date;
  final String time;
  final String type;
  final AppointmentStatus status;
  final Color avatarColor;
  final String? notes;

  MockAppointment copyWith({AppointmentStatus? status}) => MockAppointment(doctorName: doctorName, doctorInitials: doctorInitials, specialty: specialty, clinicName: clinicName, location: location, date: date, time: time, type: type, status: status ?? this.status, avatarColor: avatarColor, notes: notes);
}
