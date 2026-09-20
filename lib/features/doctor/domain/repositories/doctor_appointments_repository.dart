import '../entities/doctor_appointment_entity.dart';

abstract class DoctorAppointmentsRepository {
  Future<List<DoctorAppointmentEntity>> getDoctorAppointments();
}
