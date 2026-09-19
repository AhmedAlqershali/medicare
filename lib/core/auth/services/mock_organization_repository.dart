import '../data/mock_medicare_store.dart';
import '../models/organization.dart';
import '../repositories/organization_repository.dart';
import 'mock_auth_repository.dart';

class MockOrganizationRepository implements OrganizationRepository {
  MockOrganizationRepository._(this._store, this._auth);

  static final instance = MockOrganizationRepository._(MockMedicareStore.instance, MockAuthRepository.instance);

  final MockMedicareStore _store;
  final MockAuthRepository _auth;

  @override
  Organization? get currentOrganization {
    final id = _auth.session.organizationId;
    return id == null ? null : _store.organizationById(id);
  }

  @override
  List<Organization> visibleOrganizations() {
    final id = _auth.session.organizationId;
    if (id == null) return const [];
    final organization = _store.organizationById(id);
    return organization == null ? const [] : [organization];
  }
}
