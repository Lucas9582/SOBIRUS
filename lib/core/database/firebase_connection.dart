import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConnection {
  static FirebaseConnection? _instance;
  
  late final FirebaseFirestore _firestore;
  late final FirebaseStorage _storage;
  late final FirebaseAuth _auth;
  
  // Construtor privado (Singleton)
  FirebaseConnection._internal() {
    _firestore = FirebaseFirestore.instance;
    _storage = FirebaseStorage.instance;
    _auth = FirebaseAuth.instance;
  }
  
  // Método para obter instância única
  static FirebaseConnection getInstance() {
    _instance ??= FirebaseConnection._internal();
    return _instance!;
  }
  
  // Getters
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;
  FirebaseAuth get auth => _auth;
}
