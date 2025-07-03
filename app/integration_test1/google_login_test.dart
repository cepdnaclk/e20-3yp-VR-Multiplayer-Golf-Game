import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/screens/login_screen.dart'; // <-- Update import as needed

void main() {
  testWidgets('Google Sign-In Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.pumpAndSettle();

    final signInButton = find.byKey(const Key('googleSignInButton'));
    expect(signInButton, findsOneWidget);

    // Optional: tap the button to test interaction
    await tester.tap(signInButton);
    await tester.pumpAndSettle();
  });
}
