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
}
