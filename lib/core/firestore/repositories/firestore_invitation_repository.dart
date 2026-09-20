import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/models/account_role.dart';
import '../../auth/models/invitation.dart';
import '../../auth/models/invitation_status.dart';
import '../../auth/repositories/invitation_repository.dart';
import '../firestore_paths.dart';
import '../firestore_service.dart';

class FirestoreInvitationRepository implements InvitationRepository {
  FirestoreInvitationRepository._({FirestoreService? service}) : _service = service ?? FirestoreService();

  static final instance = FirestoreInvitationRepository._();

  final FirestoreService _service;

  @override
  List<Invitation> invitationsFor({required String organizationId, AccountRole? role}) => const [];

  @override
  Invitation? pendingInvitation({required AccountRole role, required String email}) => null;

  Future<Invitation?> fetchInvitationById(String organizationId, String invitationId) async {
    if (organizationId.trim().isEmpty || invitationId.trim().isEmpty) return null;
    final snapshot = await _service.invitationDocument(organizationId, invitationId).get();
    if (!snapshot.exists || snapshot.data() == null) return null;
    final invitation = Invitation.fromMap(snapshot.data()!);
    if (invitation.organizationId.isNotEmpty && invitation.organizationId != organizationId) {
      throw StateError('This invitation belongs to a different organization and cannot be read here.');
    }
    return invitation;
  }

  Future<Invitation?> fetchInvitationByEmail(String organizationId, String email) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty) return null;
    final snapshot = await _service.invitationCollection(organizationId)
        .where('email', isEqualTo: normalizedEmail)
        .limit(2)
        .get();
    if (snapshot.docs.isEmpty) return null;
    if (snapshot.docs.length > 1) {
      throw StateError('Multiple pending invitations were found for the same email in this organization.');
    }
    final invitation = Invitation.fromMap(snapshot.docs.first.data());
    if (invitation.organizationId.isNotEmpty && invitation.organizationId != organizationId) {
      throw StateError('This invitation belongs to a different organization and cannot be read here.');
    }
    return invitation;
  }

  Future<List<Invitation>> fetchInvitationsForOrganization(String organizationId, {AccountRole? role}) async {
    Query<Map<String, dynamic>> query = _service.invitationCollection(organizationId);
    if (role != null) {
      query = query.where('role', isEqualTo: role.name);
    }
    final snapshot = await query.get();
    return snapshot.docs
        .map((document) => Invitation.fromMap(document.data()))
        .where((invitation) => invitation.organizationId.isEmpty || invitation.organizationId == organizationId)
        .toList();
  }

  Future<void> createInvitation({required String organizationId, required Invitation invitation}) async {
    _validateInvitationOrganization(organizationId, invitation);
    if (invitation.role != AccountRole.doctor) {
      throw StateError('Only doctor invitations are supported by Firestore.');
    }
    final safeInvitation = Invitation(
      id: invitation.id,
      email: invitation.email.trim(),
      role: invitation.role,
      invitedBy: invitation.invitedBy.trim(),
      organizationId: organizationId,
      status: invitation.status,
      doctorId: invitation.doctorId,
      patientId: invitation.patientId,
    );
    await _service.invitationDocument(organizationId, safeInvitation.id).set(safeInvitation.toMap(), SetOptions(merge: true));
  }

  Future<void> saveInvitation({required String organizationId, required Invitation invitation}) async {
    await createInvitation(organizationId: organizationId, invitation: invitation);
  }

  Future<void> updateInvitationStatus({required String organizationId, required String invitationId, required InvitationStatus status}) async {
    final invitation = await fetchInvitationById(organizationId, invitationId);
    if (invitation == null) {
      throw StateError('Invitation not found in the trusted organization context.');
    }
    final updated = invitation.copyWith(status: status);
    await _service.invitationDocument(organizationId, invitationId).set(updated.toMap(), SetOptions(merge: true));
  }

  Future<Invitation> acceptInvitation({required String organizationId, required String invitationId}) async {
    final invitation = await fetchInvitationById(organizationId, invitationId);
    if (invitation == null) {
      throw StateError('Invitation not found in the trusted organization context.');
    }
    if (invitation.status != InvitationStatus.pending) {
      throw StateError('This invitation is no longer pending and cannot be accepted.');
    }
    final accepted = invitation.copyWith(status: InvitationStatus.accepted);
    await _service.invitationDocument(organizationId, invitationId).set(accepted.toMap(), SetOptions(merge: true));
    return accepted;
  }

  Future<Invitation> rejectInvitation({required String organizationId, required String invitationId}) async {
    final invitation = await fetchInvitationById(organizationId, invitationId);
    if (invitation == null) {
      throw StateError('Invitation not found in the trusted organization context.');
    }
    final rejected = invitation.copyWith(status: InvitationStatus.cancelled);
    await _service.invitationDocument(organizationId, invitationId).set(rejected.toMap(), SetOptions(merge: true));
    return rejected;
  }

  Future<Invitation> expireInvitation({required String organizationId, required String invitationId}) async {
    final invitation = await fetchInvitationById(organizationId, invitationId);
    if (invitation == null) {
      throw StateError('Invitation not found in the trusted organization context.');
    }
    final expired = invitation.copyWith(status: InvitationStatus.expired);
    await _service.invitationDocument(organizationId, invitationId).set(expired.toMap(), SetOptions(merge: true));
    return expired;
  }

  DocumentReference<Map<String, dynamic>> invitationDocument(String organizationId, String invitationId) =>
      _service.invitationDocument(organizationId, invitationId);

  DocumentReference<Map<String, dynamic>> invitationDocumentForPaths(String organizationId, String invitationId) =>
      _service.firestore.doc(FirestorePaths.invitation(organizationId, invitationId));

  void _validateInvitationOrganization(String organizationId, Invitation invitation) {
    if (organizationId.trim().isEmpty) {
      throw StateError('Organization id is required before saving an invitation.');
    }
    if (invitation.id.trim().isEmpty) {
      throw StateError('Invitation id is required before saving to Firestore.');
    }
    if (invitation.email.trim().isEmpty) {
      throw StateError('Invitation email is required before saving to Firestore.');
    }
    if (invitation.organizationId != organizationId) {
      throw StateError('Invitation organization cannot be changed from the client.');
    }
    if (invitation.role != AccountRole.doctor) {
      throw StateError('Only doctor invitations are allowed in the Firestore invitation flow.');
    }
  }
}
