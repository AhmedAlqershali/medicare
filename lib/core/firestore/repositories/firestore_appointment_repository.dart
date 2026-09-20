import '../firestore_service.dart';

class FirestoreAppointmentRepository {
  FirestoreAppointmentRepository({FirestoreService? service}) : _service = service ?? FirestoreService();

  final FirestoreService _service;

  Future<void> saveAppointment({required String organizationId, required Map<String, dynamic> appointment}) async {
    final id = appointment['id'] as String? ?? '';
    if (id.isEmpty) {
      throw StateError('Appointment id is required before saving to Firestore.');
    }
    await _service.appointmentCollection(organizationId).doc(id).set(appointment);
  }

  Future<List<Map<String, dynamic>>> fetchAppointments(String organizationId) async {
    final snapshot = await _service.appointmentCollection(organizationId).get();
    return snapshot.docs.map((document) => document.data()).toList();
  }
}
