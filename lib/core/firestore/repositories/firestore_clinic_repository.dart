import '../../auth/models/account_status.dart';
import '../../auth/models/organization.dart';
import '../firestore_service.dart';

class FirestoreClinicRepository {
  FirestoreClinicRepository({FirestoreService? service}) : _service = service ?? FirestoreService();

  final FirestoreService _service;

  Future<void> saveClinic({required String organizationId, required Map<String, dynamic> clinic}) async {
    final id = clinic['id'] as String? ?? '';
    if (id.isEmpty) {
      throw StateError('Clinic id is required before saving to Firestore.');
    }
    await _service.clinicCollection(organizationId).doc(id).set(clinic);
  }

  Future<List<Map<String, dynamic>>> fetchClinics(String organizationId) async {
    final snapshot = await _service.clinicCollection(organizationId).get();
    return snapshot.docs.map((document) => document.data()).toList();
  }

  Future<void> saveOrganization({required Organization organization}) async {
    await _service.organizationDocument(organization.id).set({
      ...organization.toMap(),
      'status': organization.status.name,
    });
  }

  Future<List<Organization>> fetchOrganizations() async {
    final snapshot = await _service.organizationCollection().get();
    return snapshot.docs
        .map((document) => Organization.fromMap(document.data()))
        .where((organization) => organization.status != AccountStatus.inactive)
        .toList();
  }
}
