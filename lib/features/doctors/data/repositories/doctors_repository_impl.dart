import '../../../../core/theme/app_theme.dart';
import '../../../../core/auth/services/firebase_auth_repository.dart';
import '../../../../core/firestore/repositories/firestore_doctor_repository.dart';
import '../../domain/entities/doctor_entity.dart';
import '../../domain/repositories/doctors_repository.dart';

class DoctorsRepositoryImpl implements DoctorsRepository {
  const DoctorsRepositoryImpl();

  @override
  Future<List<DoctorEntity>> getDoctors() async {
    final organizationId = FirebaseAuthRepository.instance.session.organizationId;
    if (organizationId == null || organizationId.isEmpty) return const [];
    final doctors = await FirestoreDoctorRepository.instance.fetchDoctorsForOrganization(organizationId);
    return doctors.map((doctor) => DoctorEntity(
      id: doctor.id,
      initials: doctor.initials,
      name: doctor.name,
      specialty: doctor.specialty,
      clinic: '',
      location: '',
      rating: '',
      reviews: '',
      experience: 0,
      bio: '',
      services: const [],
      colorValue: AppColors.sky.value,
    )).toList();
  }
}
