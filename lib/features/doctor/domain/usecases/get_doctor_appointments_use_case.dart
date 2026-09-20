import '../entities/doctor_appointment_entity.dart';
import '../repositories/doctor_appointments_repository.dart';

class GetDoctorAppointmentsUseCase {
  const GetDoctorAppointmentsUseCase(this.repository);

  final DoctorAppointmentsRepository repository;

  Future<List<DoctorAppointmentEntity>> call() => repository.getDoctorAppointments();
}
