// lib/features/profile/presentation/viewmodels/profile_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:sobrius_app/models/profile_model.dart';
import 'package:sobrius_app/features/profile_repository.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class ProfileViewModel with ChangeNotifier {
  final ProfileRepository _profileRepository;
  final String _currentUserId; // O ID do usuário logado

  ProfileModel? _currentProfile;
  XFile? _pickedImage;
  String _username = '';
  String _bio = '';
  String _personalReason = '';
  List<String> _selectedVices = [];
  DateTime? _sobrietyStartDate;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  ProfileViewModel(this._profileRepository, this._currentUserId);

  String get currentUserId => _currentUserId;

  ProfileModel? get currentProfile => _currentProfile;
  XFile? get pickedImage => _pickedImage;
  String get username => _username;
  String get bio => _bio;
  String get personalReason => _personalReason;
  List<String> get selectedVices => _selectedVices;
  DateTime? get sobrietyStartDate => _sobrietyStartDate;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    _successMessage = null;
    notifyListeners();
  }

  void _setSuccessMessage(String? message) {
    _successMessage = message;
    _errorMessage = null;
    notifyListeners();
  }

  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setBio(String value) {
    _bio = value;
    notifyListeners();
  }

  void setPersonalReason(String value) {
    _personalReason = value;
    notifyListeners();
  }

  void setSobrietyStartDate(DateTime? date) {
    _sobrietyStartDate = date;
    notifyListeners();
  }

  void toggleVice(String vice) {
    if (_selectedVices.contains(vice)) {
      _selectedVices.remove(vice);
    } else {
      _selectedVices.add(vice);
    }
    notifyListeners();
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = image;
      notifyListeners();
    }
  }

  Future<void> fetchProfile() async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _currentProfile = await _profileRepository.fetchProfile(userId: _currentUserId);
      if (_currentProfile != null) {
        _username = _currentProfile!.username;
        _bio = _currentProfile!.bio ?? '';
        _personalReason = _currentProfile!.personalReason ?? '';
        _selectedVices = List.from(_currentProfile!.vices);
        _sobrietyStartDate = _currentProfile!.sobrietyStartDate;
        _pickedImage = null;
      }
    } catch (e) {
      _setErrorMessage("Erro ao carregar perfil: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> saveProfile() async {
    _setLoading(true);
    _setErrorMessage(null);
    _setSuccessMessage(null);

    // Adiciona a validação para o nome de usuário e a data de início
    if (_username.isEmpty) {
      _setErrorMessage("O nome de usuário não pode ser vazio.");
      _setLoading(false);
      return;
    }

    if (_sobrietyStartDate == null) {
      _setErrorMessage("Por favor, selecione a data de início da sua jornada.");
      _setLoading(false);
      return;
    }

    try {
      String? avatarUrl = _currentProfile?.avatarUrl;

      if (_pickedImage != null) {
        avatarUrl = await _profileRepository.uploadProfileImage(_currentUserId, File(_pickedImage!.path));
        // Se o upload falhar, o método vai lançar uma exceção que será capturada abaixo.
      }

      final newProfile = ProfileModel(
        id: _currentUserId,
        username: _username,
        bio: _bio,
        personalReason: _personalReason,
        vices: _selectedVices,
        avatarUrl: avatarUrl,
        sobrietyStartDate: _sobrietyStartDate,
      );

      await _profileRepository.saveProfile(newProfile);
      _currentProfile = newProfile;
      _setSuccessMessage("Perfil salvo com sucesso!");
    } catch (e) {
      // Captura qualquer erro de upload ou salvamento no banco de dados.
      _setErrorMessage("Erro ao salvar perfil: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Método dedicado para atualizar apenas a data de sobriedade.
  Future<void> updateSobrietyStartDate(DateTime newDate) async {
    if (_isLoading) return;

    _setLoading(true);
    _setErrorMessage(null);
    _setSuccessMessage(null);

    if (newDate == null) {
      _setErrorMessage("A data de sobriedade não pode ser nula.");
      _setLoading(false);
      return;
    }

    try {
      await _profileRepository.updateSobrietyStartDate(userId: _currentUserId, newDate: newDate);
      _sobrietyStartDate = newDate;
      _setSuccessMessage("Data de sobriedade atualizada com sucesso!");
    } catch (e) {
      _setErrorMessage("Erro ao atualizar data de sobriedade: $e");
    } finally {
      _setLoading(false);
    }
  }

  /// Método público para resetar o contador de sobriedade para a data e hora atuais.
  Future<void> resetSobrietyStartDate() async {
    await updateSobrietyStartDate(DateTime.now());
  }
}
