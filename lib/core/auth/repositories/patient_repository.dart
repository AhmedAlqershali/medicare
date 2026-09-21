import '../models/patient.dart';

abstract class PatientRepository {
  Future<List<Patient>> patientsForDoctor(String doctorId);
  Future<Patient?> patientForId(String patientId);
  Future<Patient> createPatient({required String doctorId, required String name, required String email, required String invitedBy});
}
