import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final _db = FirebaseFirestore.instance;

  Future<void> setUser(String uid, Map<String, dynamic> data) =>
      _db.collection('users').doc(uid).set(data);

  Future<void> setCompany(String companyId, Map<String, dynamic> data) =>
      _db.collection('companies').doc(companyId).set(data);

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser(String uid) =>
      _db.collection('users').doc(uid).get();

  Future<DocumentSnapshot<Map<String, dynamic>>> getCompany(String companyId) =>
      _db.collection('companies').doc(companyId).get();

  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUser(String uid) =>
      _db.collection('users').doc(uid).snapshots();

  Future<void> updateUser(String uid, Map<String, dynamic> data) =>
      _db.collection('users').doc(uid).update(data);

  WriteBatch batch() => _db.batch();

  DocumentReference<Map<String, dynamic>> newCompanyRef() =>
      _db.collection('companies').doc();
}
