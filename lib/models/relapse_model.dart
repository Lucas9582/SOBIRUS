// lib/models/relapse_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class RelapseModel {
  final String id;
  final String userId;
  final DateTime relapseDate;

  const RelapseModel({
    required this.id,
    required this.userId,
    required this.relapseDate,
  });

  // Converte um DocumentSnapshot do Firestore em um objeto RelapseModel
  factory RelapseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RelapseModel(
      id: doc.id,
      userId: data['userId'] as String,
      relapseDate: (data['relapseDate'] as Timestamp).toDate(),
    );
  }

  // Converte o objeto RelapseModel em um mapa para o Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'relapseDate': Timestamp.fromDate(relapseDate),
    };
  }
}
