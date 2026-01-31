import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fix_my_town/core/widgets/my_text_form_field_login.dart';
import 'package:fix_my_town/features/auth/presentation/pages/mobile_signup_screen.dart';
import 'package:fix_my_town/features/auth/presentation/state/auth_state.dart';
import 'package:fix_my_town/features/auth/presentation/view_model/auth_viewmodel.dart';

class FakeAuthViewModel extends AuthViewmodel {
  @override
  AuthState build() {
    return AuthState(status: AuthStatus.initial);
  }
}

void main() {
  testWidgets("Should have all input fields", (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authViewmodelProvider.overrideWith(FakeAuthViewModel.new)],
        child: const MaterialApp(home: MobileSignupScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Find input fields by type
    Finder nameField = find.byType(MyTextFormFieldLogin).at(0);
    Finder emailField = find.byType(MyTextFormFieldLogin).at(1);
    Finder passwordField = find.byType(MyTextFormFieldLogin).at(2);
    Finder confirmPasswordField = find.byType(MyTextFormFieldLogin).at(3);

    expect(nameField, findsOneWidget);
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(confirmPasswordField, findsOneWidget);
  });

  testWidgets("Should have Sign Up title", (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authViewmodelProvider.overrideWith(FakeAuthViewModel.new)],
        child: const MaterialApp(home: MobileSignupScreen()),
      ),
    );
    await tester.pumpAndSettle();

    Finder signUpTitle = find.text("Sign Up");
    expect(signUpTitle, findsOneWidget);
  });

  testWidgets("Should have Signup button", (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authViewmodelProvider.overrideWith(FakeAuthViewModel.new)],
        child: const MaterialApp(home: MobileSignupScreen()),
      ),
    );
    await tester.pumpAndSettle();

    Finder signupButton = find.widgetWithText(ElevatedButton, "Signup");
    expect(signupButton, findsOneWidget);
  });

  testWidgets("Should have login navigation button", (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authViewmodelProvider.overrideWith(FakeAuthViewModel.new)],
        child: const MaterialApp(home: MobileSignupScreen()),
      ),
    );
    await tester.pumpAndSettle();

    Finder loginButton = find.widgetWithText(
      TextButton,
      "Already have an account?",
    );
    expect(loginButton, findsOneWidget);
  });
}
