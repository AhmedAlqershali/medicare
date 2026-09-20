class FirestorePaths {
  const FirestorePaths._();

  static const String organizations = 'organizations';
  static const String doctors = 'doctors';
  static const String patients = 'patients';
  static const String clinics = 'clinics';
  static const String appointments = 'appointments';
  static const String invitations = 'invitations';

  static String organization(String organizationId) => '$organizations/$organizationId';
  static String doctor(String doctorId) => '$doctors/$doctorId';
  static String doctorForOrganization(String organizationId, String doctorId) => '$organizations/$organizationId/$doctors/$doctorId';
  static String patient(String patientId) => '$patients/$patientId';
  static String patientForDoctor(String organizationId, String doctorId, String patientId) => '$organizations/$organizationId/$doctors/$doctorId/$patients/$patientId';
  static String clinic(String organizationId, String clinicId) => '$organizations/$organizationId/$clinics/$clinicId';
  static String appointment(String organizationId, String appointmentId) => '$organizations/$organizationId/$appointments/$appointmentId';
  static String invitation(String organizationId, String invitationId) => '$organizations/$organizationId/$invitations/$invitationId';
}
