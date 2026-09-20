import '../../data/mock_organization_doctors.dart';
import '../../domain/repositories/organization_doctors_repository.dart';
import '../../models/organization_doctor.dart';

class OrganizationDoctorsRepositoryImpl implements OrganizationDoctorsRepository {
  const OrganizationDoctorsRepositoryImpl();

  @override
  Future<List<OrganizationDoctor>> getOrganizationDoctors() async {
    return List<OrganizationDoctor>.from(mockOrganizationDoctors);
  }
}
