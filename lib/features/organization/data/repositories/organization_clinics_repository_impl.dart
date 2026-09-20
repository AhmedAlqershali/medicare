import '../../data/mock_organization_clinics.dart';
import '../../domain/entities/organization_clinic_entity.dart';
import '../../domain/repositories/organization_clinics_repository.dart';

class OrganizationClinicsRepositoryImpl implements OrganizationClinicsRepository {
  const OrganizationClinicsRepositoryImpl();

  @override
  Future<List<OrganizationClinicEntity>> getOrganizationClinics() async {
    return mockOrganizationClinics.map((clinic) => OrganizationClinicEntity(
      id: clinic.id,
      name: clinic.name,
      location: clinic.location,
      phone: clinic.phone,
      description: clinic.description,
      status: clinic.status,
      doctorsCount: clinic.doctorsCount,
      departmentsCount: clinic.departmentsCount,
      patientsCount: clinic.patientsCount,
      iconCodePoint: clinic.icon.codePoint,
      colorValue: clinic.color.value,
      departments: List<String>.from(clinic.departments),
    )).toList();
  }
}
