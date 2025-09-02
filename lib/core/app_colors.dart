import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF4A8C9E); // Azul esverdeado principal
  static const Color accentColor = Color(0xFF6B9EA8); // Azul esverdeado mais claro para alguns elementos
  static const Color secondaryColor = Color(0xFFB0BEC5); // Cinza/Azul claro para fundo de cards/detalhes
  static const Color backgroundColor = Color(0xFFE0E0E0); // Fundo geral cinza muito claro
  static const Color textColor = Colors.white; // Texto branco em fundo escuro
  static const Color darkTextColor = Color(0xFF424242); // Texto escuro para fundos claros

  // Cores do calendário
  static const Color recaidaColor = Colors.red;
  static const Color sobrioColor = Colors.yellow;
  static const Color inicioProgressoColor = Colors.green;

  // Cores de gradientes (para botões)
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF6B9EA8), Color(0xFF4A8C9E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient loginButtonGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFE0E0E0)], // Branco para cinza claro
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient googleButtonGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFE0E0E0)], // Branco para cinza claro
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}