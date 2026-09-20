import '../../auth/models/account_status.dart';
import '../../auth/models/organization.dart';
import '../../auth/repositories/organization_repository.dart';
import '../firestore_service.dart';

class FirestoreOrganizationRepository implements OrganizationRepository {
  FirestoreOrganizationRepository({FirestoreService? service}) : _service = service ?? FirestoreService();

  final FirestoreService _service;

  @override
  Organization? get currentOrganization => null;

  @override
  List<Organization> visibleOrganizations() => const [];

  Future<void> saveOrganization({required Organization organization}) async {
    await _service.organizationDocument(organization.id).set(organization.toMap());
  }

  Future<Organization?> fetchOrganization(String organizationId) async {
    final snapshot = await _service.organizationDocument(organizationId).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return Organization.fromMap(snapshot.data()!);
  }

  Future<List<Organization>> fetchOrganizations() async {
    final snapshot = await _service.organizationCollection().get();
    return snapshot.docs
        .map((document) => Organization.fromMap(document.data()))
        .where((organization) => organization.status != AccountStatus.inactive)
        .toList();
  }
}
