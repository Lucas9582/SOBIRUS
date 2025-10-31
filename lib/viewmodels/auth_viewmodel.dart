// lib/viewmodels/auth_viewmodel.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sobrius_app/features/profile_repository.dart';

class AuthViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ProfileRepository _profileRepository;
  
  late final Future<void> authReady;

  User? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;

  AuthViewModel(this._profileRepository) {
    authReady = _initializeAuth();
  }
  
  Future<void> _initializeAuth() async {
    try {
      _currentUser = _auth.currentUser;
      notifyListeners();
      
      await _auth.authStateChanges()
          .first
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () => _auth.currentUser,
          );
      
      _currentUser = _auth.currentUser;
      notifyListeners();
      
      _auth.authStateChanges().listen((User? user) {
        _currentUser = user;
        notifyListeners();
      });
    } catch (e) {
      print('Erro ao inicializar autenticação: $e');
      _currentUser = _auth.currentUser;
      notifyListeners();
    }
  }

  bool get isAuthenticated => _currentUser != null;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> signInWithEmailPassword(String email, String password) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _setErrorMessage(_mapFirebaseAuthExceptionMessage(e.code));
    } catch (e) {
      _setErrorMessage('Ocorreu um erro inesperado. Tente novamente.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      _setErrorMessage(_mapFirebaseAuthExceptionMessage(e.code));
    } catch (e) {
      _setErrorMessage('Ocorreu um erro inesperado. Tente novamente.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      _setErrorMessage('Um link para redefinir sua senha foi enviado para $email.');
    } on FirebaseAuthException catch (e) {
      _setErrorMessage(_mapFirebaseAuthExceptionMessage(e.code));
    } catch (e) {
      _setErrorMessage('Ocorreu um erro inesperado. Tente novamente.');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _auth.signOut();
    } catch (e) {
      _setErrorMessage("Erro ao fazer logout: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> doesProfileExist() async {
    if (_currentUser == null) {
      return false;
    }
    
    try {
      final profile = await _profileRepository
          .fetchProfile(userId: _currentUser!.uid)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => null,
          );
      return profile != null;
    } catch (e) {
      print('Erro ao verificar perfil: $e');
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  String _mapFirebaseAuthExceptionMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'Nenhum usuário encontrado para este e-mail.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'email-already-in-use':
        return 'O e-mail já está em uso por outra conta.';
      case 'invalid-email':
        return 'O e-mail fornecido não é válido.';
      case 'weak-password':
        return 'A senha deve ter no mínimo 6 caracteres.';
      case 'user-disabled':
        return 'Sua conta foi desabilitada. Por favor, entre em contato com o suporte.';
      default:
        return 'Erro de autenticação: $errorCode';
    }
  }
}
```

---

## ✅ CHECKLIST FINAL
```
□ Copiei o código do ARQUIVO 1 (main.dart)
□ Colei no meu lib/main.dart
□ Salvei o arquivo
□ Copiei o código do ARQUIVO 2 (auth_viewmodel.dart)
□ Colei no meu lib/viewmodels/auth_viewmodel.dart
□ Salvei o arquivo
□ Executei: flutter clean
□ Executei: flutter pub get
□ Executei: flutter run
□ Testei o app!
