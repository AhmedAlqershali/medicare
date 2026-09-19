import 'package:flutter/material.dart';

class AppointmentBookingData {
  const AppointmentBookingData({
    required this.doctorName,
    required this.doctorInitials,
    required this.specialty,
    required this.clinicName,
    required this.location,
    required this.avatarColor,
  });

  final String doctorName;
  final String doctorInitials;
  final String specialty;
  final String clinicName;
  final String location;
  final Color avatarColor;
}