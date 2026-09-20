import '../../data/mock_patient_profile.dart';
import '../../domain/entities/patient_profile.dart';
import '../../domain/repositories/patient_profile_repository.dart';

class PatientProfileRepositoryImpl implements PatientProfileRepository {
  const PatientProfileRepositoryImpl();

  @override
  Future<PatientProfileEntity> getPatientProfile() async {
    final profile = mockPatientProfile;
    return PatientProfileEntity(
      name: profile.name,
      phone: profile.phone,
      email: profile.email,
      birthDate: profile.birthDate,
      gender: profile.gender,
    );
  }
}
