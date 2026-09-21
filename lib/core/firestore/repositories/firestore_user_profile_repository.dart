import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/models/account_role.dart';
import '../firestore_service.dart';
import '../models/user_profile.dart';

class FirestoreUserProfileRepository {
  FirestoreUserProfileRepository({FirestoreService? service}) : _service = service ?? FirestoreService();

  final FirestoreService _service;

  CollectionReference<Map<String, dynamic>> get _usersCollection => _service.firestore.collection('users');

  Future<UserProfile?> fetchUserProfile(String uid) async {
    final snapshot = await _usersCollection.doc(uid).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    return UserProfile.fromMap(snapshot.data()!);
  }

  Future<UserProfile> createOrUpdateUserProfile({
    required String uid,
    required String email,
    required AccountRole role,
    String? organizationId,
    String? clinicId,
    String? invitationId,
    String? doctorId,
    String? patientId,
  }) async {
    final now = DateTime.now();
    final existing = await fetchUserProfile(uid);
    final profile = UserProfile(
      uid: uid,
      email: email.trim(),
      role: role,
      organizationId: organizationId,
      clinicId: clinicId,
      doctorId: doctorId,
      patientId: patientId,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    final profileMap = profile.toMap();
    if (invitationId != null) profileMap['invitationId'] = invitationId;
    await _usersCollection.doc(uid).set(profileMap, SetOptions(merge: true));
    return profile;
  }

  Future<void> linkPatientProfile({
    required String uid,
    required String patientId,
    required String doctorId,
    required String organizationId,
  }) async {
    await _usersCollection.doc(uid).set({
      'uid': uid,
      'patientId': patientId,
      'doctorId': doctorId,
      'organizationId': organizationId,
      'role': AccountRole.patient.name,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> linkDoctorProfile({
    required String uid,
    required String doctorId,
    required String organizationId,
  }) async {
    await _usersCollection.doc(uid).set({
      'uid': uid,
      'doctorId': doctorId,
      'organizationId': organizationId,
      'role': AccountRole.doctor.name,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> linkOrganizationProfile({
    required String uid,
    required String email,
    required String organizationId,
    String? clinicId,
    String? invitationId,
  }) async {
    final profile = <String, dynamic>{
      'uid': uid,
      'email': email.trim(),
      'organizationId': organizationId,
      'clinicId': clinicId,
      'role': AccountRole.organization.name,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (invitationId != null) profile['invitationId'] = invitationId;
    await _usersCollection.doc(uid).set(profile, SetOptions(merge: true));
  }
}
