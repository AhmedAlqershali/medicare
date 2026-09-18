import 'package:flutter/material.dart';

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

class ClinicDoctorData {
  const ClinicDoctorData({required this.initials, required this.name, required this.specialty, required this.rating, required this.reviews, required this.experience, required this.bio, required this.services, required this.color});
  final String initials;
  final String name;
  final String specialty;
  final String rating;
  final String reviews;
  final int experience;
  final String bio;
  final List<String> services;
  final Color color;
}
