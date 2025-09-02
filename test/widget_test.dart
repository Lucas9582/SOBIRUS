// test/widget_test.dart
// import 'package:flutter/material.dart'; // <<< REMOVIDO: Unused import
import 'package:flutter_test/flutter_test.dart';
import 'package:sobrius_app/app/app_widget.dart'; // Certifique-se de importar AppWidget

void main() {
  testWidgets('Sobrius App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AppWidget());
    // Se o seu app tem uma tela inicial, pode verificar um texto nela.
    // Por exemplo, na WelcomePage, pode haver "Bem-vindo ao Sobrius!"
    // expect(find.text('Bem-vindo ao Sobrius!'), findsOneWidget);
  });
}