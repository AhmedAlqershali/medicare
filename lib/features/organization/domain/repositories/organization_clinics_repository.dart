import '../entities/organization_clinic_entity.dart';

abstract class OrganizationClinicsRepository {
  Future<List<OrganizationClinicEntity>> getOrganizationClinics();
}
