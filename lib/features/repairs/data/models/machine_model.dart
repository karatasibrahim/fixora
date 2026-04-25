import 'package:cloud_firestore/cloud_firestore.dart';

class MachineModel {
  final String id;
  final String companyId;
  final String name;
  final String type;
  final String location;
  final String status; // 'normal' | 'warning' | 'critical' | 'maintenance'
  final int healthScore; // 0-100
  final String? manufacturer;
  final String? model;
  final DateTime? installDate;
  final String? notes;
  final DateTime createdAt;
  final String createdBy;

  const MachineModel({
    required this.id,
    required this.companyId,
    required this.name,
    required this.type,
    required this.location,
    required this.status,
    required this.healthScore,
    this.manufacturer,
    this.model,
    this.installDate,
    this.notes,
    required this.createdAt,
    required this.createdBy,
  });

  double get healthFraction => healthScore / 100.0;

  factory MachineModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return MachineModel(
      id: doc.id,
      companyId: d['companyId'] as String? ?? '',
      name: d['name'] as String? ?? '',
      type: d['type'] as String? ?? '',
      location: d['location'] as String? ?? '',
      status: d['status'] as String? ?? 'normal',
      healthScore: (d['healthScore'] as num?)?.toInt() ?? 100,
      manufacturer: d['manufacturer'] as String?,
      model: d['model'] as String?,
      installDate:
          (d['installDate'] as Timestamp?)?.toDate(),
      notes: d['notes'] as String?,
      createdAt:
          (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: d['createdBy'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'companyId': companyId,
        'name': name,
        'type': type,
        'location': location,
        'status': status,
        'healthScore': healthScore,
        if (manufacturer != null) 'manufacturer': manufacturer,
        if (model != null) 'model': model,
        if (installDate != null) 'installDate': Timestamp.fromDate(installDate!),
        if (notes != null) 'notes': notes,
        'createdAt': Timestamp.fromDate(createdAt),
        'createdBy': createdBy,
      };
}
