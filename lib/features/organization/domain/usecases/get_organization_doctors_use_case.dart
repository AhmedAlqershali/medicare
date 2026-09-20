import '../entities/organization_doctor_entity.dart';
import '../repositories/organization_doctors_repository.dart';

class GetOrganizationDoctorsUseCase {
  const GetOrganizationDoctorsUseCase(this.repository);

  final OrganizationDoctorsRepository repository;

  Future<List<OrganizationDoctorEntity>> call() => repository.getOrganizationDoctors();
}
