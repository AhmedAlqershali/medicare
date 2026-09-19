import '../models/doctor.dart';

abstract class DoctorRepository {
  List<Doctor> doctorsForOrganization(String organizationId);
  Doctor? doctorForId(String doctorId);
  Doctor inviteDoctor({required String organizationId, required String name, required String email, required String specialty, required String invitedBy});
}
