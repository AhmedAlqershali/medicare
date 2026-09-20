class FirestorePaths {
  const FirestorePaths._();

  static const String organizations = 'organizations';
  static const String doctors = 'doctors';
  static const String patients = 'patients';
  static const String clinics = 'clinics';
  static const String appointments = 'appointments';

  static String organization(String organizationId) => '$organizations/$organizationId';
  static String doctor(String organizationId, String doctorId) => '$organizations/$organizationId/$doctors/$doctorId';
  static String patient(String organizationId, String doctorId, String patientId) => '$organizations/$organizationId/$doctors/$doctorId/$patients/$patientId';
  static String clinic(String organizationId, String clinicId) => '$organizations/$organizationId/$clinics/$clinicId';
  static String appointment(String organizationId, String appointmentId) => '$organizations/$organizationId/$appointments/$appointmentId';
}
