import 'package:flutter/material.dart';

import '../../../../core/auth/services/firebase_auth_repository.dart';
import '../../../../core/firestore/repositories/firestore_appointment_repository.dart';
import '../../domain/repositories/doctor_appointments_repository.dart';
import '../../models/doctor_appointment.dart';

class DoctorAppointmentsRepositoryImpl implements DoctorAppointmentsRepository {
  const DoctorAppointmentsRepositoryImpl();

  @override
  Future<List<DoctorAppointment>> getDoctorAppointments() async {
    final session = FirebaseAuthRepository.instance.session;
    final organizationId = session.organizationId;
    final doctorId = session.doctorId;
    if (organizationId == null || doctorId == null || organizationId.isEmpty || doctorId.isEmpty) return const [];
    final appointments = await FirestoreAppointmentRepository.instance.fetchAppointments(organizationId);
    return appointments.where((appointment) => appointment['doctorId'] == doctorId).map(_fromMap).toList();
  }

  DoctorAppointment _fromMap(Map<String, dynamic> appointment) => DoctorAppointment(
        patientName: appointment['patientName'] as String? ?? '',
        patientInitials: appointment['patientInitials'] as String? ?? '',
        age: appointment['age'] as String? ?? '',
        gender: appointment['gender'] as String? ?? '',
        date: appointment['date'] as String? ?? '',
        time: appointment['time'] as String? ?? '',
        type: appointment['type'] as String? ?? '',
        status: _statusFromMap(appointment['status']),
        notes: appointment['notes'] as String? ?? '',
        avatarColor: Colors.transparent,
      );

  DoctorAppointmentFilter _statusFromMap(Object? value) => switch (value) {
        'completed' => DoctorAppointmentFilter.completed,
        'cancelled' => DoctorAppointmentFilter.cancelled,
        'today' => DoctorAppointmentFilter.today,
        _ => DoctorAppointmentFilter.upcoming,
      };
}
