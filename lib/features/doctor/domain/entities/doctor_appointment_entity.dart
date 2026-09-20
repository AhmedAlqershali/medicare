enum DoctorAppointmentEntityFilter { today, upcoming, completed, cancelled }

class DoctorAppointmentEntity {
  const DoctorAppointmentEntity({
    required this.patientName,
    required this.patientInitials,
    required this.age,
    required this.gender,
    required this.date,
    required this.time,
    required this.type,
    required this.status,
    required this.notes,
    required this.avatarColorValue,
  });

  final String patientName;
  final String patientInitials;
  final String age;
  final String gender;
  final String date;
  final String time;
  final String type;
  final DoctorAppointmentEntityFilter status;
  final String? notes;
  final int avatarColorValue;
}
