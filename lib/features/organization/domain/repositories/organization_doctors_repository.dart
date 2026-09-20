import '../entities/organization_doctor_entity.dart';

abstract class OrganizationDoctorsRepository {
  Future<List<OrganizationDoctorEntity>> getOrganizationDoctors();
}
