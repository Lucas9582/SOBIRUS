import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ViewModel para gerenciar a lógica e o estado do timer.
class TimerViewModel extends ChangeNotifier {
  static const _startTimeKey = 'startTime';
  DateTime? _startTime;
  Timer? _timer;
  Duration _duration = Duration.zero;

  TimerViewModel() {
    _loadStartTime();
    _startTimer();
  }

  // Retorna a duração formatada em dias, horas, minutos e segundos.
  String get formattedDuration {
    final days = _duration.inDays;
    final hours = _duration.inHours % 24;
    final minutes = _duration.inMinutes % 60;
    final seconds = _duration.inSeconds % 60;
    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  // Carrega o horário de início salvo no SharedPreferences.
  Future<void> _loadStartTime() async {
    final prefs = await SharedPreferences.getInstance();
    final startTimeMillis = prefs.getInt(_startTimeKey);
    if (startTimeMillis != null) {
      _startTime = DateTime.fromMillisecondsSinceEpoch(startTimeMillis);
      _calculateDuration();
    } else {
      // Se não houver horário, inicia um novo timer.
      resetTimer();
    }
  }

  // Inicia um timer periódico para atualizar o tempo a cada segundo.
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateDuration();
    });
  }

  // Calcula a diferença de tempo desde o início e notifica os listeners.
  void _calculateDuration() {
    if (_startTime != null) {
      final now = DateTime.now();
      _duration = now.difference(_startTime!);
      notifyListeners();
    }
  }

  // Reseta o timer para o horário atual e salva no SharedPreferences.
  Future<void> resetTimer() async {
    _startTime = DateTime.now();
    _duration = Duration.zero;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_startTimeKey, _startTime!.millisecondsSinceEpoch);
    notifyListeners();
  }

  // Cancela o timer quando o ViewModel é descartado para evitar vazamento de memória.
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
