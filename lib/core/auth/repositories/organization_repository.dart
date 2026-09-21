import '../models/organization.dart';

abstract class OrganizationRepository {
  Future<Organization?> currentOrganization();
  Future<List<Organization>> visibleOrganizations();
}
