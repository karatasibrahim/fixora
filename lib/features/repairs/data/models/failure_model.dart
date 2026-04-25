import 'package:cloud_firestore/cloud_firestore.dart';

class FailureModel {
  final String id;
  final String companyId;
  final String machineId;
  final String machineName;
  final String type;
  final String severity; // 'low' | 'medium' | 'high' | 'critical'
  final String description;
  final String reportedBy;
  final String reportedByName;
  final DateTime reportedAt;
  final List<String> imageUrls;

  const FailureModel({
    required this.id,
    required this.companyId,
    required this.machineId,
    required this.machineName,
    required this.type,
    required this.severity,
    required this.description,
    required this.reportedBy,
    required this.reportedByName,
    required this.reportedAt,
    this.imageUrls = const [],
  });

  factory FailureModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return FailureModel(
      id: doc.id,
      companyId: d['companyId'] as String? ?? '',
      machineId: d['machineId'] as String? ?? '',
      machineName: d['machineName'] as String? ?? '',
      type: d['type'] as String? ?? '',
      severity: d['severity'] as String? ?? 'medium',
      description: d['description'] as String? ?? '',
      reportedBy: d['reportedBy'] as String? ?? '',
      reportedByName: d['reportedByName'] as String? ?? '',
      reportedAt:
          (d['reportedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      imageUrls: List<String>.from(d['imageUrls'] as List? ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
        'companyId': companyId,
        'machineId': machineId,
        'machineName': machineName,
        'type': type,
        'severity': severity,
        'description': description,
        'reportedBy': reportedBy,
        'reportedByName': reportedByName,
        'reportedAt': Timestamp.fromDate(reportedAt),
        'imageUrls': imageUrls,
      };
}
