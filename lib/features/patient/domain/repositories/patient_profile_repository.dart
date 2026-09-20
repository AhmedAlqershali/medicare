import '../entities/patient_profile.dart';

abstract class PatientProfileRepository {
  Future<PatientProfileEntity> getPatientProfile();
}
