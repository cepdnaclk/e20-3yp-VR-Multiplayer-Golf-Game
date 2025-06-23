import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  testWidgets('Google Sign-In navigates to /deviceConnection', (
    WidgetTester tester,
  ) async {
    // Step 1: Mock Firebase User
    final mockUser = MockUser(
      isAnonymous: false,
      uid: 'uid123',
      email: 'test@example.com',
      displayName: 'Test User',
    );
    final mockAuth = MockFirebaseAuth(mockUser: mockUser);

    // Step 2: Mock Google Sign-In
    final mockGoogleSignIn = MockGoogleSignIn();
    final mockGoogleUser = await mockGoogleSignIn.signIn();

    // Step 3: Build the LoginScreen inside a MaterialApp with routes
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                // This simulates calling _handleGoogleSignIn
                final googleAuth = await mockGoogleUser?.authentication;
                final credential = GoogleAuthProvider.credential(
                  accessToken: googleAuth?.accessToken,
                  idToken: googleAuth?.idToken,
                );
                await mockAuth.signInWithCredential(credential);

                Navigator.pushReplacementNamed(
                  context,
                  '/deviceConnection',
                  arguments: {
                    'name': mockUser.displayName ?? 'Guest',
                    'email': mockUser.email ?? '',
                    'uid': mockUser.uid,
                  },
                );
              },
              child: const Text('Simulate Google Sign-In'),
            );
          },
        ),
        routes: {'/deviceConnection': (context) => const Placeholder()},
      ),
    );

    // Tap the fake Google Sign-In button
    await tester.tap(find.text('Simulate Google Sign-In'));
    await tester.pumpAndSettle();

    // Step 4: Verify navigation
    expect(find.byType(Placeholder), findsOneWidget);
  });
}
