import '../../../../core/auth/services/firebase_auth_repository.dart';
import '../../../../core/firestore/repositories/firestore_patient_repository.dart';
import '../../domain/entities/patient_profile.dart';
import '../../domain/repositories/patient_profile_repository.dart';

class PatientProfileRepositoryImpl implements PatientProfileRepository {
  const PatientProfileRepositoryImpl();

  @override
  Future<PatientProfileEntity> getPatientProfile() async {
    final patientId = FirebaseAuthRepository.instance.session.patientId;
    if (patientId == null || patientId.isEmpty) {
      throw StateError('لا توجد جلسة مريض نشطة.');
    }
    final profile = await FirestorePatientRepository.instance.fetchPatientById(patientId);
    if (profile == null) throw StateError('لم يتم العثور على ملف المريض.');
    return PatientProfileEntity(
      name: profile.name,
      phone: '',
      email: profile.email,
      birthDate: '',
      gender: '',
    );
  }
}
