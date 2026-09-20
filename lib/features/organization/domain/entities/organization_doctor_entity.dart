class OrganizationDoctorEntity {
  const OrganizationDoctorEntity({
    required this.id,
    required this.name,
    required this.initials,
    required this.specialty,
    required this.clinic,
    required this.phone,
    required this.email,
    required this.status,
    required this.avatarColorValue,
    required this.scheduleSummary,
  });

  final String id;
  final String name;
  final String initials;
  final String specialty;
  final String clinic;
  final String phone;
  final String email;
  final String status;
  final int avatarColorValue;
  final String scheduleSummary;
}
