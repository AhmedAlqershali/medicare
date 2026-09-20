import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  FirebaseFirestore get firestore => _firestore;

  CollectionReference<Map<String, dynamic>> organizationCollection() => _firestore.collection('organizations');

  CollectionReference<Map<String, dynamic>> doctorCollection(String organizationId) => _firestore.collection('organizations').doc(organizationId).collection('doctors');

  CollectionReference<Map<String, dynamic>> patientCollection(String organizationId, String doctorId) => _firestore.collection('organizations').doc(organizationId).collection('doctors').doc(doctorId).collection('patients');

  CollectionReference<Map<String, dynamic>> clinicCollection(String organizationId) => _firestore.collection('organizations').doc(organizationId).collection('clinics');

  CollectionReference<Map<String, dynamic>> appointmentCollection(String organizationId) => _firestore.collection('organizations').doc(organizationId).collection('appointments');

  DocumentReference<Map<String, dynamic>> organizationDocument(String organizationId) => _firestore.collection('organizations').doc(organizationId);

  DocumentReference<Map<String, dynamic>> doctorDocument(String organizationId, String doctorId) => _firestore.collection('organizations').doc(organizationId).collection('doctors').doc(doctorId);

  DocumentReference<Map<String, dynamic>> patientDocument(String organizationId, String doctorId, String patientId) => _firestore.collection('organizations').doc(organizationId).collection('doctors').doc(doctorId).collection('patients').doc(patientId);
}
