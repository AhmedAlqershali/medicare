import '../../data/mock_doctor_appointments.dart';
import '../../domain/repositories/doctor_appointments_repository.dart';
import '../../models/doctor_appointment.dart';

class DoctorAppointmentsRepositoryImpl implements DoctorAppointmentsRepository {
  const DoctorAppointmentsRepositoryImpl();

  @override
  Future<List<DoctorAppointment>> getDoctorAppointments() async {
    return List<DoctorAppointment>.from(doctorAppointments);
  }
}
