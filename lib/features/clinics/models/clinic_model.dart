import 'package:flutter/material.dart';

part 'clinic_model_clinic_doctor_data.dart';


class ClinicData {
  const ClinicData({required this.name, required this.category, required this.location, required this.description, required this.hours, required this.specialties, required this.doctors, required this.status, required this.icon, required this.color});
  final String name;
  final String category;
  final String location;
  final String description;
  final String hours;
  final List<String> specialties;
  final List<ClinicDoctorData> doctors;
  final String status;
  final IconData icon;
  final Color color;
}
