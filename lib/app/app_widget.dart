// lib/app/app_widget.dart
import 'package:flutter/material.dart';
import 'package:sobrius_app/app/app_router.dart'; // <<< Adicione este import
import 'package:sobrius_app/shared/app_theme.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sobrius App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter, // <<< Corrigido para 'appRouter'
    );
  }
}