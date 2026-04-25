import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/machine_model.dart';

class MachineRepository {
  final _col = FirebaseFirestore.instance.collection('machines');

  Stream<List<MachineModel>> watchMachines(String companyId) {
    return _col
        .where('companyId', isEqualTo: companyId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(MachineModel.fromDoc).toList());
  }

  Future<void> addMachine(MachineModel machine) {
    return _col.add(machine.toMap());
  }

  Future<void> updateMachine(String id, Map<String, dynamic> data) {
    return _col.doc(id).update(data);
  }

  Future<void> deleteMachine(String id) {
    return _col.doc(id).delete();
  }
}
