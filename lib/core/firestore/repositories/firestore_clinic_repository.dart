import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/models/account_status.dart';
import '../../auth/models/organization.dart';
import '../firestore_paths.dart';
import '../firestore_service.dart';

class FirestoreClinicRepository {
  FirestoreClinicRepository._({FirestoreService? service}) : _service = service ?? FirestoreService();

  static final instance = FirestoreClinicRepository._();

  final FirestoreService _service;

  Future<Map<String, dynamic>?> fetchClinicById(String organizationId, String clinicId) async {
    final snapshot = await _service.clinicDocument(organizationId, clinicId).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    final clinic = snapshot.data()!;
    if (clinic['organizationId'] != null && clinic['organizationId'] != organizationId) {
      throw StateError('This clinic belongs to a different organization and cannot be read here.');
    }
    return clinic;
  }

  Future<List<Map<String, dynamic>>> fetchClinicsForOrganization(String organizationId) async {
    final snapshot = await _service.clinicCollection(organizationId).get();
    return snapshot.docs
        .map((document) => {...document.data(), 'id': document.id})
        .where((clinic) => clinic['organizationId'] == organizationId)
        .toList();
  }

  Future<Map<String, dynamic>> createClinic({required String organizationId, required Map<String, dynamic> clinic}) async {
    final clinicId = (clinic['id'] as String? ?? '').trim();
    if (clinicId.isEmpty) {
      throw StateError('Clinic id is required before creating a Firestore record.');
    }
    final safeClinic = <String, dynamic>{
      ...clinic,
      'id': clinicId,
      'organizationId': organizationId,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _service.clinicDocument(organizationId, clinicId).set(safeClinic, SetOptions(merge: true));
    return safeClinic;
  }

  Future<void> saveClinic({required String organizationId, required Map<String, dynamic> clinic}) async {
    final clinicId = (clinic['id'] as String? ?? '').trim();
    if (clinicId.isEmpty) {
      throw StateError('Clinic id is required before saving to Firestore.');
    }
    final requestedOrganizationId = (clinic['organizationId'] as String?) ?? organizationId;
    if (requestedOrganizationId != organizationId) {
      throw StateError('Clinic organization cannot be changed from the client.');
    }
    final safeClinic = <String, dynamic>{
      ...clinic,
      'id': clinicId,
      'organizationId': organizationId,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await _service.clinicDocument(organizationId, clinicId).set(safeClinic, SetOptions(merge: true));
  }

  Future<void> deleteClinic({required String organizationId, required String clinicId}) async {
    await _service.clinicDocument(organizationId, clinicId).delete();
  }

  Future<void> saveOrganization({required Organization organization}) async {
    if (organization.id.trim().isEmpty) {
      throw StateError('Organization id is required before saving to Firestore.');
    }
    await _service.organizationDocument(organization.id).set({
      ...organization.toMap(),
      'status': organization.status.name,
    });
  }

  Future<List<Organization>> fetchOrganizations() async {
    final snapshot = await _service.organizationCollection().get();
    return snapshot.docs
      .map((document) => Organization.fromMap(document.data(), document.id))
        .where((organization) => organization.status != AccountStatus.inactive)
        .toList();
  }

  DocumentReference<Map<String, dynamic>> clinicDocument(String organizationId, String clinicId) => _service.clinicDocument(organizationId, clinicId);

  DocumentReference<Map<String, dynamic>> clinicDocumentForPaths(String organizationId, String clinicId) => _service.clinicDocument(organizationId, clinicId);
}
