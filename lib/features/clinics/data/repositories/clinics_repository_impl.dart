import '../../data/mock_clinics.dart';
import '../../domain/entities/clinic_entity.dart';
import '../../domain/repositories/clinics_repository.dart';

class ClinicsRepositoryImpl implements ClinicsRepository {
  const ClinicsRepositoryImpl();

  @override
  Future<List<ClinicEntity>> getClinics() async {
    return clinics.map((clinic) => ClinicEntity(
      name: clinic.name,
      category: clinic.category,
      location: clinic.location,
      description: clinic.description,
      hours: clinic.hours,
      specialties: List<String>.from(clinic.specialties),
      status: clinic.status,
      icon: clinic.icon,
      colorValue: clinic.color.value,
      doctors: clinic.doctors.map((doctor) => ClinicDoctorEntity(
        initials: doctor.initials,
        name: doctor.name,
        specialty: doctor.specialty,
        rating: doctor.rating,
        reviews: doctor.reviews,
        experience: doctor.experience,
        bio: doctor.bio,
        services: List<String>.from(doctor.services),
        colorValue: doctor.color.value,
      )).toList(),
    )).toList();
  }
}
