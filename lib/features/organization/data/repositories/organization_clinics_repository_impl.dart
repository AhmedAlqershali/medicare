import '../../data/mock_organization_clinics.dart';
import '../../domain/repositories/organization_clinics_repository.dart';
import '../../models/organization_clinic.dart';

class OrganizationClinicsRepositoryImpl implements OrganizationClinicsRepository {
  const OrganizationClinicsRepositoryImpl();

  @override
  Future<List<OrganizationClinic>> getOrganizationClinics() async {
    return List<OrganizationClinic>.from(mockOrganizationClinics);
  }
}
