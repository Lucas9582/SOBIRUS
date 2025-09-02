// lib/features/auth/presentation/viewmodels/auth_viewmodel.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:google_sign_in/google_sign_in.dart'; // Importe para o Google Sign-In
import 'package:sobrius_app/features/profile_repository.dart'; // Importe o ProfileRepository

class AuthViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ProfileRepository _profileRepository; // Injetar o ProfileRepository
  
  // Future que indica que a autenticação está pronta
  late final Future<void> authReady;

  User? _currentUser;
  String? _errorMessage;
  bool _isLoading = false;

  AuthViewModel(this._profileRepository) { // Construtor que recebe o ProfileRepository
    // Escuta as mudanças no estado de autenticação do Firebase
    authReady = _initializeAuth();
  }
  
  Future<void> _initializeAuth() async {
    await _auth.authStateChanges().first;
    _currentUser = _auth.currentUser;
    notifyListeners();
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  // --- Getters para o estado da UI ---
  bool get isAuthenticated => _currentUser != null;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  // --- Métodos de Autenticação ---

  /// Autentica um usuário com e-mail e senha.
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

  /// Cria um novo usuário com e-mail e senha.
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

  /// Autentica um usuário usando a conta do Google.
/*  Future<void> signInWithGoogle() async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _setErrorMessage('Login com Google cancelado.');
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      _setErrorMessage(_mapFirebaseAuthExceptionMessage(e.code));
    } catch (e) {
      _setErrorMessage("Erro ao entrar com Google: $e");
    } finally {
      _setLoading(false);
    }
  }
*/
  /// Envia um e-mail para redefinir a senha do usuário.
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

  /// Realiza o logout do usuário.
  Future<void> signOut() async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _auth.signOut();
//      await _googleSignIn.signOut(); // Adiciona logout do Google
    } catch (e) {
      _setErrorMessage("Erro ao fazer logout: $e");
    } finally {
      _setLoading(false);
    }
  }

  // NOVO MÉTODO: Verificar se o perfil já existe
  Future<bool> doesProfileExist() async {
    if (_currentUser == null) {
      return false; // Se não há usuário logado, não há perfil.
    }
    // Usa o ProfileRepository para verificar
    final profile = await _profileRepository.fetchProfile(userId: _currentUser!.uid);
    return profile != null;
  }

  // --- Métodos Auxiliares ---

  /// Atualiza o estado de carregamento e notifica os listeners.
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Atualiza a mensagem de erro e notifica os listeners.
  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  /// Mapeia códigos de erro do Firebase para mensagens amigáveis.
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
