import 'package:flutter/material.dart';

class OrganizationDoctor {
  const OrganizationDoctor({required this.id, required this.name, required this.initials, required this.specialty, required this.clinic, required this.phone, required this.email, required this.status, required this.avatarColor, required this.scheduleSummary});
  final String id;
  final String name;
  final String initials;
  final String specialty;
  final String clinic;
  final String phone;
  final String email;
  final String status;
  final Color avatarColor;
  final String scheduleSummary;

  OrganizationDoctor copyWith({String? name, String? initials, String? specialty, String? clinic, String? phone, String? email, String? status, Color? avatarColor, String? scheduleSummary}) => OrganizationDoctor(id: id, name: name ?? this.name, initials: initials ?? this.initials, specialty: specialty ?? this.specialty, clinic: clinic ?? this.clinic, phone: phone ?? this.phone, email: email ?? this.email, status: status ?? this.status, avatarColor: avatarColor ?? this.avatarColor, scheduleSummary: scheduleSummary ?? this.scheduleSummary);
}
