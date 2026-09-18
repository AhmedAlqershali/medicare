import 'package:flutter/material.dart';

class DoctorData {
  const DoctorData({required this.initials, required this.name, required this.specialty, required this.clinic, required this.location, required this.rating, required this.reviews, required this.experience, required this.bio, required this.services, required this.color});
  final String initials;
  final String name;
  final String specialty;
  final String clinic;
  final String location;
  final String rating;
  final String reviews;
  final int experience;
  final String bio;
  final List<String> services;
  final Color color;
}
