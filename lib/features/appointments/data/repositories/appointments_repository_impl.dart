import 'package:flutter/material.dart';

import '../../../../core/auth/services/firebase_auth_repository.dart';
import '../../../../core/firestore/repositories/firestore_appointment_repository.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointments_repository.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  const AppointmentsRepositoryImpl();

  @override
  Future<List<AppointmentEntity>> getAppointments() async {
    final organizationId = FirebaseAuthRepository.instance.session.organizationId;
    if (organizationId == null || organizationId.isEmpty) return const [];
    final patientId = FirebaseAuthRepository.instance.session.patientId;
    if (patientId == null || patientId.isEmpty) return const [];
    final appointments = await FirestoreAppointmentRepository.instance.fetchAppointments(organizationId);
    return appointments
      .where((appointment) => appointment['patientId'] == patientId)
        .map(_fromMap)
        .toList();
  }

  AppointmentEntity _fromMap(Map<String, dynamic> appointment) => AppointmentEntity(
      id: appointment['id'] as String? ?? '',
        doctorName: appointment['doctorName'] as String? ?? '',
        doctorInitials: appointment['doctorInitials'] as String? ?? '',
        specialty: appointment['specialty'] as String? ?? '',
        clinicName: appointment['clinicName'] as String? ?? '',
        location: appointment['location'] as String? ?? '',
        date: appointment['date'] as String? ?? '',
        time: appointment['time'] as String? ?? '',
        type: appointment['type'] as String? ?? '',
        status: _statusFromMap(appointment['status']),
        avatarColorValue: appointment['avatarColorValue'] as int? ?? Colors.transparent.value,
        notes: appointment['notes'] as String?,
      );

  AppointmentEntityStatus _statusFromMap(Object? value) => switch (value) {
        'completed' => AppointmentEntityStatus.completed,
        'cancelled' => AppointmentEntityStatus.cancelled,
        _ => AppointmentEntityStatus.upcoming,
      };

}
