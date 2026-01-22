// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:first_flutter/data/models/sentence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:first_flutter/main.dart';
import 'package:first_flutter/data/repositories/sentence_repository.dart';
import 'package:first_flutter/data/services/sentence_service.dart';

void main() {
  Widget crearMultiProvider() {
    return MultiProvider(
      providers: [
        Provider<ISentenceService>(create: (_) => FakeSentenceService()),
        Provider<ISentenceRepository>(
          create: (context) =>
              SentenceRepository(sentenceService: context.read()),
        ),
      ],
      child: const MyApp(),
    );
  }

  testWidgets('Test clicar botó Next', (WidgetTester tester) async {
    await tester.pumpWidget(crearMultiProvider());
    await tester.pumpAndSettle();
    // Busquem el botó Next i el cliquem
    final nextButton = find.widgetWithText(ElevatedButton, 'Next');
    expect(nextButton, findsOneWidget);
    await tester.tap(nextButton);
    await tester.pumpAndSettle();
    //La frase encara hi és (perquè el mock sempre retorna el mateix)
    expect(find.text('Test sentence'), findsNWidgets(2));
  });
  testWidgets('Test mostra frase inicial', (WidgetTester tester) async {
    await tester.pumpWidget(crearMultiProvider());
    await tester.pumpAndSettle();
    expect(find.text('Test sentence'), findsOneWidget);
  });
}

class FakeSentenceService implements ISentenceService {
  @override
  Future<Sentence> getNext() async {
    // Retornem una frase fixa, sense HTTP!
    return Sentence(text: 'Test sentence');
  }

  @override
  Future<Sentence> createSentence(String text) async {
    return Sentence(text: text);
  }
}
