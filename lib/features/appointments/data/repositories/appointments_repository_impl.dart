import '../mock_appointments.dart';
import '../../models/appointment_status.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/repositories/appointments_repository.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  const AppointmentsRepositoryImpl();

  @override
  Future<List<AppointmentEntity>> getAppointments() async {
    return mockAppointments.map((appointment) => AppointmentEntity(
      doctorName: appointment.doctorName,
      doctorInitials: appointment.doctorInitials,
      specialty: appointment.specialty,
      clinicName: appointment.clinicName,
      location: appointment.location,
      date: appointment.date,
      time: appointment.time,
      type: appointment.type,
      status: _statusToEntity(appointment.status),
      avatarColorValue: appointment.avatarColor.value,
      notes: appointment.notes,
    )).toList();
  }

  AppointmentEntityStatus _statusToEntity(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.upcoming:
        return AppointmentEntityStatus.upcoming;
      case AppointmentStatus.completed:
        return AppointmentEntityStatus.completed;
      case AppointmentStatus.cancelled:
        return AppointmentEntityStatus.cancelled;
    }
  }
}
