import '../../data/mock_organization_doctors.dart';
import '../../domain/entities/organization_doctor_entity.dart';
import '../../domain/repositories/organization_doctors_repository.dart';

class OrganizationDoctorsRepositoryImpl implements OrganizationDoctorsRepository {
  const OrganizationDoctorsRepositoryImpl();

  @override
  Future<List<OrganizationDoctorEntity>> getOrganizationDoctors() async {
    return mockOrganizationDoctors.map((doctor) => OrganizationDoctorEntity(
      id: doctor.id,
      name: doctor.name,
      initials: doctor.initials,
      specialty: doctor.specialty,
      clinic: doctor.clinic,
      phone: doctor.phone,
      email: doctor.email,
      status: doctor.status,
      avatarColorValue: doctor.avatarColor.value,
      scheduleSummary: doctor.scheduleSummary,
    )).toList();
  }
}
