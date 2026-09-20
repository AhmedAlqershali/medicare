import '../../../../core/theme/app_theme.dart';
import '../../data/mock_doctors.dart';
import '../../domain/entities/doctor_entity.dart';
import '../../domain/repositories/doctors_repository.dart';

class DoctorsRepositoryImpl implements DoctorsRepository {
  const DoctorsRepositoryImpl();

  @override
  Future<List<DoctorEntity>> getDoctors() async {
    return doctors.map((doctor) => DoctorEntity(
      initials: doctor.initials,
      name: doctor.name,
      specialty: doctor.specialty,
      clinic: doctor.clinic,
      location: doctor.location,
      rating: doctor.rating,
      reviews: doctor.reviews,
      experience: doctor.experience,
      bio: doctor.bio,
      services: List<String>.from(doctor.services),
      colorValue: (doctor.color ?? AppColors.sky).value,
    )).toList();
  }
}
