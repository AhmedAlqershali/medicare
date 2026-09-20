import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  FirebaseFirestore get firestore => _firestore;

  CollectionReference<Map<String, dynamic>> organizationCollection() => _firestore.collection('organizations');

  CollectionReference<Map<String, dynamic>> doctorCollection() => _firestore.collection('doctors');

  CollectionReference<Map<String, dynamic>> doctorCollectionForOrganization(String organizationId) => _firestore.collection('organizations').doc(organizationId).collection('doctors');

  CollectionReference<Map<String, dynamic>> patientCollection() => _firestore.collection('patients');

  CollectionReference<Map<String, dynamic>> patientCollectionForDoctor(String organizationId, String doctorId) => _firestore.collection('organizations').doc(organizationId).collection('doctors').doc(doctorId).collection('patients');

  CollectionReference<Map<String, dynamic>> clinicCollection(String organizationId) => _firestore.collection('organizations').doc(organizationId).collection('clinics');

  CollectionReference<Map<String, dynamic>> appointmentCollection(String organizationId) => _firestore.collection('organizations').doc(organizationId).collection('appointments');

  CollectionReference<Map<String, dynamic>> invitationCollection(String organizationId) => _firestore.collection('organizations').doc(organizationId).collection('invitations');

  DocumentReference<Map<String, dynamic>> organizationDocument(String organizationId) => _firestore.collection('organizations').doc(organizationId);

  DocumentReference<Map<String, dynamic>> doctorDocument(String doctorId) => _firestore.collection('doctors').doc(doctorId);

  DocumentReference<Map<String, dynamic>> doctorDocumentForOrganization(String organizationId, String doctorId) => _firestore.collection('organizations').doc(organizationId).collection('doctors').doc(doctorId);

  DocumentReference<Map<String, dynamic>> patientDocument(String patientId) => _firestore.collection('patients').doc(patientId);

  DocumentReference<Map<String, dynamic>> patientDocumentForDoctor(String organizationId, String doctorId, String patientId) => _firestore.collection('organizations').doc(organizationId).collection('doctors').doc(doctorId).collection('patients').doc(patientId);

  DocumentReference<Map<String, dynamic>> appointmentDocument(String organizationId, String appointmentId) =>
      _firestore.collection('organizations').doc(organizationId).collection('appointments').doc(appointmentId);

  DocumentReference<Map<String, dynamic>> invitationDocument(String organizationId, String invitationId) =>
      _firestore.collection('organizations').doc(organizationId).collection('invitations').doc(invitationId);
}
