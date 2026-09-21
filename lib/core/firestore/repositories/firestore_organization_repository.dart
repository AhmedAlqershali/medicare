import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../auth/models/account_status.dart';
import '../../auth/models/organization.dart';
import '../../auth/repositories/organization_repository.dart';
import '../firestore_paths.dart';
import '../firestore_service.dart';

class FirestoreOrganizationRepository implements OrganizationRepository {
  FirestoreOrganizationRepository._({FirestoreService? service}) : _service = service ?? FirestoreService();

  static final instance = FirestoreOrganizationRepository._();

  final FirestoreService _service;

  @override
  Future<Organization?> currentOrganization() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) return null;
    return fetchOrganizationByUid(uid);
  }

  @override
  Future<List<Organization>> visibleOrganizations() => fetchOrganizations();

  Future<Organization?> fetchOrganizationById(String organizationId) async {
    final snapshot = await _service.organizationDocument(organizationId).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return Organization.fromMap(snapshot.data()!);
  }

  Future<Organization?> fetchOrganizationByUid(String firebaseUid) async {
    final snapshot = await _service.firestore.collection(FirestorePaths.organizations).where('firebaseUid', isEqualTo: firebaseUid).limit(2).get();
    if (snapshot.docs.isEmpty) return null;
    if (snapshot.docs.length > 1) {
      throw StateError('تم العثور على أكثر من مؤسسة مرتبطة بنفس Firebase UID.');
    }
    return Organization.fromMap(snapshot.docs.first.data());
  }

  Future<Organization?> fetchOrganizationByEmail(String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    final snapshot = await _service.firestore.collection(FirestorePaths.organizations).where('email', isEqualTo: normalizedEmail).limit(2).get();
    if (snapshot.docs.isEmpty) return null;
    if (snapshot.docs.length > 1) {
      throw StateError('تم العثور على أكثر من مؤسسة بنفس البريد الإلكتروني.');
    }
    return Organization.fromMap(snapshot.docs.first.data());
  }

  Future<void> saveOrganization(Organization organization) async {
    await _service.organizationDocument(organization.id).set(organization.toMap(), SetOptions(merge: true));
  }

  Future<void> linkFirebaseUid({required String organizationId, required String firebaseUid, required String email}) async {
    final organization = await fetchOrganizationById(organizationId);
    if (organization == null) {
      throw StateError('لم يتم العثور على المؤسسة المطلوبة.');
    }
    if (organization.email.trim().toLowerCase() != email.trim().toLowerCase()) {
      throw StateError('البريد الإلكتروني للمؤسسة غير مطابق للسجل الموجود.');
    }
    if (organization.firebaseUid != null && organization.firebaseUid != firebaseUid) {
      throw StateError('هذه المؤسسة مرتبطة بالفعل بحساب Firebase مختلف ولا يمكن نقله.');
    }

    final updatedOrganization = Organization(
      id: organization.id,
      name: organization.name,
      email: organization.email,
      phone: organization.phone,
      location: organization.location,
      status: organization.status,
      firebaseUid: firebaseUid,
      createdAt: organization.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await saveOrganization(updatedOrganization);
  }

  Future<List<Organization>> fetchOrganizations() async {
    final snapshot = await _service.organizationCollection().get();
    return snapshot.docs
        .map((document) => Organization.fromMap(document.data()))
        .where((organization) => organization.status != AccountStatus.inactive)
        .toList();
  }
}
