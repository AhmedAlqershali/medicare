import '../models/account_role.dart';
import '../models/account_status.dart';
import '../models/auth_user.dart';
import '../models/doctor.dart';
import '../models/invitation.dart';
import '../models/invitation_status.dart';
import '../models/organization.dart';
import '../models/patient.dart';

class MockMedicareStore {
  MockMedicareStore._();

  static final instance = MockMedicareStore._();

  final organizations = <Organization>[
    const Organization(id: 'org_001', name: 'Gaza Medical Center', email: 'admin@gaza-medical.sa', phone: '059 111 2233', location: 'غزة، فلسطين', status: AccountStatus.active),
    const Organization(id: 'org_002', name: 'Al-Shifa Medical Clinic', email: 'admin@alshifa-medical.sa', phone: '059 444 5566', location: 'غزة، فلسطين', status: AccountStatus.active),
  ];

  final doctors = <Doctor>[
    const Doctor(id: 'doc_001', name: 'د. أحمد العتيبي', email: 'ahmed.alotaibi@example.com', organizationId: 'org_001', specialty: 'طب عام', status: AccountStatus.active, initials: 'أ ع'),
    const Doctor(id: 'doc_002', name: 'د. ليان السالم', email: 'lian.alsalem@example.com', organizationId: 'org_001', specialty: 'طب أطفال', status: AccountStatus.active, initials: 'ل س'),
    const Doctor(id: 'doc_003', name: 'د. عمر أبو زيد', email: 'omar.abouzaid@example.com', organizationId: 'org_002', specialty: 'جلدية', status: AccountStatus.active, initials: 'ع ز'),
  ];

  final patients = <Patient>[
    const Patient(id: 'pat_001', name: 'سارة أحمد', email: 'sara.ahmed@example.com', doctorId: 'doc_001', organizationId: 'org_001', status: AccountStatus.active, initials: 'س أ'),
    const Patient(id: 'pat_002', name: 'خالد محمد', email: 'khaled.mohamed@example.com', doctorId: 'doc_001', organizationId: 'org_001', status: AccountStatus.active, initials: 'خ م'),
    const Patient(id: 'pat_003', name: 'نورة علي', email: 'noura.ali@example.com', doctorId: 'doc_002', organizationId: 'org_001', status: AccountStatus.active, initials: 'ن ع'),
    const Patient(id: 'pat_004', name: 'ريم فهد', email: 'reem.fahad@example.com', doctorId: 'doc_003', organizationId: 'org_002', status: AccountStatus.active, initials: 'ر ف'),
  ];

  final invitations = <Invitation>[];
  final passwords = <String, String>{
    'org_001': 'medicare123',
    'org_002': 'medicare123',
    'doc_001': 'medicare123',
    'doc_002': 'medicare123',
    'doc_003': 'medicare123',
    'pat_001': 'medicare123',
    'pat_002': 'medicare123',
    'pat_003': 'medicare123',
    'pat_004': 'medicare123',
  };

  AuthUser? findUser({required AccountRole role, required String email}) {
    final normalizedEmail = email.trim().toLowerCase();
    if (role == AccountRole.organization) {
      for (final organization in organizations) {
        if (organization.email.toLowerCase() == normalizedEmail && organization.status == AccountStatus.active) {
          return AuthUser(id: organization.id, name: organization.name, email: organization.email, role: role, organizationId: organization.id);
        }
      }
    }
    if (role == AccountRole.doctor) {
      for (final doctor in doctors) {
        if (doctor.email.toLowerCase() == normalizedEmail && doctor.status == AccountStatus.active) {
          return AuthUser(id: doctor.id, name: doctor.name, email: doctor.email, role: role, organizationId: doctor.organizationId, doctorId: doctor.id);
        }
      }
    }
    if (role == AccountRole.patient) {
      for (final patient in patients) {
        if (patient.email.toLowerCase() == normalizedEmail && patient.status == AccountStatus.active) {
          return AuthUser(id: patient.id, name: patient.name, email: patient.email, role: role, organizationId: patient.organizationId, doctorId: patient.doctorId, patientId: patient.id);
        }
      }
    }
    return null;
  }

  Doctor? doctorById(String id) => doctors.where((doctor) => doctor.id == id).firstOrNull;

  Patient? patientById(String id) => patients.where((patient) => patient.id == id).firstOrNull;

  Organization? organizationById(String id) => organizations.where((organization) => organization.id == id).firstOrNull;

  Invitation? invitationById(String id) => invitations.where((invitation) => invitation.id == id).firstOrNull;

  void activateInvitation({required Invitation invitation, required String password}) {
    if (invitation.role == AccountRole.doctor && invitation.doctorId != null) {
      final index = doctors.indexWhere((doctor) => doctor.id == invitation.doctorId);
      if (index != -1) {
        final doctor = doctors[index];
        doctors[index] = Doctor(id: doctor.id, name: doctor.name, email: doctor.email, organizationId: doctor.organizationId, specialty: doctor.specialty, status: AccountStatus.active, initials: doctor.initials);
        passwords[doctor.id] = password;
      }
    }
    if (invitation.role == AccountRole.patient && invitation.patientId != null) {
      final index = patients.indexWhere((patient) => patient.id == invitation.patientId);
      if (index != -1) {
        final patient = patients[index];
        patients[index] = Patient(id: patient.id, name: patient.name, email: patient.email, doctorId: patient.doctorId, organizationId: patient.organizationId, status: AccountStatus.active, initials: patient.initials);
        passwords[patient.id] = password;
      }
    }
    final index = invitations.indexWhere((item) => item.id == invitation.id);
    if (index != -1) invitations[index] = invitation.copyWith(status: InvitationStatus.accepted);
  }

  Doctor addDoctor({required String organizationId, required String name, required String email, required String specialty, required String invitedBy}) {
    final id = 'doc_${(doctors.length + 1).toString().padLeft(3, '0')}';
    final doctor = Doctor(id: id, name: name, email: email, organizationId: organizationId, specialty: specialty, status: AccountStatus.pending, initials: _initials(name));
    doctors.add(doctor);
    invitations.add(Invitation(id: 'invite_doc_${invitations.length + 1}', email: email, role: AccountRole.doctor, invitedBy: invitedBy, organizationId: organizationId, status: InvitationStatus.pending, doctorId: id));
    return doctor;
  }

  Patient addPatient({required String doctorId, required String name, required String email, required String invitedBy}) {
    final doctor = doctorById(doctorId)!;
    final id = 'pat_${(patients.length + 1).toString().padLeft(3, '0')}';
    final patient = Patient(id: id, name: name, email: email, doctorId: doctorId, organizationId: doctor.organizationId, status: AccountStatus.pending, initials: _initials(name));
    patients.add(patient);
    invitations.add(Invitation(id: 'invite_pat_${invitations.length + 1}', email: email, role: AccountRole.patient, invitedBy: invitedBy, organizationId: doctor.organizationId, status: InvitationStatus.pending, patientId: id));
    return patient;
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.length == 1) return parts.first.characters.first;
    return '${parts.first.characters.first} ${parts.last.characters.first}';
  }
}
