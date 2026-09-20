import 'account_role.dart';
import 'invitation_status.dart';

class Invitation {
  const Invitation({
    required this.id,
    required this.email,
    required this.role,
    required this.invitedBy,
    required this.organizationId,
    required this.status,
    this.doctorId,
    this.patientId,
  });

  final String id;
  final String email;
  final AccountRole role;
  final String invitedBy;
  final String organizationId;
  final InvitationStatus status;
  final String? doctorId;
  final String? patientId;

  Invitation copyWith({InvitationStatus? status}) => Invitation(
        id: id,
        email: email,
        role: role,
        invitedBy: invitedBy,
        organizationId: organizationId,
        status: status ?? this.status,
        doctorId: doctorId,
        patientId: patientId,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'role': role.name,
        'invitedBy': invitedBy,
        'organizationId': organizationId,
        'status': status.name,
        'doctorId': doctorId,
        'patientId': patientId,
      };

  static Invitation fromMap(Map<String, dynamic> map) => Invitation(
        id: map['id'] as String? ?? '',
        email: map['email'] as String? ?? '',
        role: AccountRole.values.firstWhere(
          (item) => item.name == (map['role'] as String? ?? AccountRole.patient.name),
          orElse: () => AccountRole.patient,
        ),
        invitedBy: map['invitedBy'] as String? ?? '',
        organizationId: map['organizationId'] as String? ?? '',
        status: InvitationStatus.values.firstWhere(
          (item) => item.name == (map['status'] as String? ?? InvitationStatus.pending.name),
          orElse: () => InvitationStatus.pending,
        ),
        doctorId: map['doctorId'] as String?,
        patientId: map['patientId'] as String?,
      );
}
