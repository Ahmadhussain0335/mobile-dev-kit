import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop/loading_card.dart';

void main() {
  testWidgets('shows spinner then text', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoadingCard()));
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('golden', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoadingCard(loaded: true)));
    await expectLater(find.byType(LoadingCard), matchesGoldenFile('goldens/loading_card.png'));
  });
}
