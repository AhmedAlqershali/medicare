class OrganizationClinicEntity {
  const OrganizationClinicEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.phone,
    required this.description,
    required this.status,
    required this.doctorsCount,
    required this.departmentsCount,
    required this.patientsCount,
    required this.iconCodePoint,
    required this.colorValue,
    required this.departments,
  });

  final String id;
  final String name;
  final String location;
  final String phone;
  final String description;
  final String status;
  final int doctorsCount;
  final int departmentsCount;
  final int patientsCount;
  final int iconCodePoint;
  final int colorValue;
  final List<String> departments;
}
