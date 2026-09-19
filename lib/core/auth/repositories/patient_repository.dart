import '../models/patient.dart';

abstract class PatientRepository {
  List<Patient> patientsForDoctor(String doctorId);
  Patient? patientForId(String patientId);
  Patient invitePatient({required String doctorId, required String name, required String email, required String invitedBy});
}
