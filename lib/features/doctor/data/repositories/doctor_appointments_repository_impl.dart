import '../../../../core/theme/app_theme.dart';
import '../../data/mock_doctor_appointments.dart';
import '../../domain/entities/doctor_appointment_entity.dart';
import '../../domain/repositories/doctor_appointments_repository.dart';
import '../../models/doctor_appointment.dart';

class DoctorAppointmentsRepositoryImpl implements DoctorAppointmentsRepository {
  const DoctorAppointmentsRepositoryImpl();

  @override
  Future<List<DoctorAppointmentEntity>> getDoctorAppointments() async {
    return doctorAppointments.map((appointment) => DoctorAppointmentEntity(
      patientName: appointment.patientName,
      patientInitials: appointment.patientInitials,
      age: appointment.age,
      gender: appointment.gender,
      date: appointment.date,
      time: appointment.time,
      type: appointment.type,
      status: _statusToEntity(appointment.status),
      notes: appointment.notes,
      avatarColorValue: (appointment.avatarColor ?? AppColors.sky).value,
    )).toList();
  }

  DoctorAppointmentEntityFilter _statusToEntity(DoctorAppointmentFilter status) {
    switch (status) {
      case DoctorAppointmentFilter.today:
        return DoctorAppointmentEntityFilter.today;
      case DoctorAppointmentFilter.upcoming:
        return DoctorAppointmentEntityFilter.upcoming;
      case DoctorAppointmentFilter.completed:
        return DoctorAppointmentEntityFilter.completed;
      case DoctorAppointmentFilter.cancelled:
        return DoctorAppointmentEntityFilter.cancelled;
    }
  }
}
