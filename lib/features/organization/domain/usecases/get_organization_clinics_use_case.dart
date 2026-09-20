import '../entities/organization_clinic_entity.dart';
import '../repositories/organization_clinics_repository.dart';

class GetOrganizationClinicsUseCase {
  const GetOrganizationClinicsUseCase(this.repository);

  final OrganizationClinicsRepository repository;

  Future<List<OrganizationClinicEntity>> call() => repository.getOrganizationClinics();
}
