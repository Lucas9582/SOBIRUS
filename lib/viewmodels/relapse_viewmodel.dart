// lib/features/calendar/presentation/viewmodels/relapse_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:sobrius_app/models/relapse_model.dart';
import 'package:sobrius_app/features/relapse_repository.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';
import 'dart:async'; // Importado para usar StreamSubscription

final logger = Logger();
const uuid = Uuid();

class RelapseViewModel with ChangeNotifier {
  final RelapseRepository _relapseRepository;
  final String _currentUserId;

  // Variável para armazenar a inscrição na stream
  StreamSubscription<List<RelapseModel>>? _relapsesSubscription;

  List<RelapseModel> _relapses = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  RelapseViewModel(this._relapseRepository, this._currentUserId) {
    // Inicia a escuta da stream assim que o ViewModel é criado
    _relapsesSubscription = _relapseRepository
        .fetchRelapses(_currentUserId)
        .listen((relapses) {
      _relapses = relapses;
      _setLoading(false); // Garante que o loading para
      notifyListeners();
    }, onError: (e) {
      _setErrorMessage('Erro ao carregar recaídas: $e');
      logger.e("Erro na stream de recaídas", error: e);
    });
  }

  // Getter público para o ID do usuário
  String get currentUserId => _currentUserId;

  List<RelapseModel> get relapses => _relapses;
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

  // Método público para adicionar uma nova recaída.
  // Ele abstrai a lógica de salvar para a data atual.
  Future<void> addRelapse() async {
    await saveRelapse(DateTime.now());
  }

  Future<void> saveRelapse(DateTime date) async {
    _setLoading(true);
    _setErrorMessage(null);
    _setSuccessMessage(null);

    try {
      final newId = uuid.v4();
      final relapse = RelapseModel(
        id: newId,
        userId: _currentUserId,
        relapseDate: date,
      );
      await _relapseRepository.saveRelapse(relapse);
      // A chamada para fetchRelapses não é mais necessária,
      // pois a stream já cuida da atualização em tempo real.
      _setSuccessMessage('Recaída registrada com sucesso!');
    } catch (e) {
      _setErrorMessage('Erro ao registrar recaída: $e');
      logger.e("Erro ao salvar recaída", error: e);
    } finally {
      _setLoading(false);
    }
  }

  // O método fetchRelapses foi removido, pois a lógica de escuta
  // agora está no construtor. Você não precisa mais chamá-lo.
  // A stream do repositório se encarrega de tudo.

  // Método crucial para liberar recursos quando o ViewModel não for mais usado
  // Isso evita vazamentos de memória.
  @override
  void dispose() {
    _relapsesSubscription?.cancel();
    super.dispose();
  }
}
