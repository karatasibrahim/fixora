import 'package:cloud_firestore/cloud_firestore.dart';

class MaintenanceModel {
  final String id;
  final String companyId;
  final String machineId;
  final String machineName;
  final String task;
  final DateTime scheduledDate;
  final bool isOverdue;
  final String status; // 'pending' | 'completed'
  final DateTime createdAt;

  const MaintenanceModel({
    required this.id,
    required this.companyId,
    required this.machineId,
    required this.machineName,
    required this.task,
    required this.scheduledDate,
    required this.isOverdue,
    required this.status,
    required this.createdAt,
  });

  factory MaintenanceModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    final scheduled =
        (d['scheduledDate'] as Timestamp?)?.toDate() ?? DateTime.now();
    final status = d['status'] as String? ?? 'pending';
    return MaintenanceModel(
      id: doc.id,
      companyId: d['companyId'] as String? ?? '',
      machineId: d['machineId'] as String? ?? '',
      machineName: d['machineName'] as String? ?? '',
      task: d['task'] as String? ?? '',
      scheduledDate: scheduled,
      isOverdue: status == 'pending' && scheduled.isBefore(DateTime.now()),
      status: status,
      createdAt:
          (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'companyId': companyId,
        'machineId': machineId,
        'machineName': machineName,
        'task': task,
        'scheduledDate': Timestamp.fromDate(scheduledDate),
        'isOverdue': isOverdue,
        'status': status,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
