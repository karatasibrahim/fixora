import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/failure_model.dart';
import '../models/maintenance_model.dart';

class FailureRepository {
  final _failures = FirebaseFirestore.instance.collection('failures');
  final _maintenance = FirebaseFirestore.instance.collection('maintenance');

  Stream<List<FailureModel>> watchFailures(
    String companyId, {
    String? machineId,
    int? limit,
  }) {
    // machineId + orderBy birlikte composite index gerektirir.
    // machineId varsa client-side sıralama yaparak single-field index yeterli olur.
    if (machineId != null) {
      return _failures
          .where('companyId', isEqualTo: companyId)
          .where('machineId', isEqualTo: machineId)
          .snapshots()
          .map((s) {
            final list = s.docs.map(FailureModel.fromDoc).toList()
              ..sort((a, b) => b.reportedAt.compareTo(a.reportedAt));
            return limit != null ? list.take(limit).toList() : list;
          });
    }

    Query<Map<String, dynamic>> q = _failures
        .where('companyId', isEqualTo: companyId)
        .orderBy('reportedAt', descending: true);
    if (limit != null) {
      q = q.limit(limit);
    }
    return q
        .snapshots()
        .map((s) => s.docs.map(FailureModel.fromDoc).toList());
  }

  Future<void> addFailure(FailureModel failure) {
    return _failures.add(failure.toMap());
  }

  Stream<List<MaintenanceModel>> watchMaintenance(
    String companyId, {
    String? machineId,
    int? limit,
  }) {
    if (machineId != null) {
      return _maintenance
          .where('companyId', isEqualTo: companyId)
          .where('machineId', isEqualTo: machineId)
          .where('status', isEqualTo: 'pending')
          .snapshots()
          .map((s) {
            final list = s.docs.map(MaintenanceModel.fromDoc).toList()
              ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
            return limit != null ? list.take(limit).toList() : list;
          });
    }

    Query<Map<String, dynamic>> q = _maintenance
        .where('companyId', isEqualTo: companyId)
        .where('status', isEqualTo: 'pending')
        .orderBy('scheduledDate');
    if (limit != null) {
      q = q.limit(limit);
    }
    return q
        .snapshots()
        .map((s) => s.docs.map(MaintenanceModel.fromDoc).toList());
  }

  Future<void> addMaintenance(MaintenanceModel m) {
    return _maintenance.add(m.toMap());
  }

  Future<void> completeMaintenance(String id) {
    return _maintenance.doc(id).update({'status': 'completed'});
  }
}
