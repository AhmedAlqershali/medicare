import '../models/organization.dart';

abstract class OrganizationRepository {
  Organization? get currentOrganization;
  List<Organization> visibleOrganizations();
}
