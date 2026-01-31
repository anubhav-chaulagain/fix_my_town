import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fix_my_town/core/widgets/my_text_form_field_login.dart';
import 'package:fix_my_town/features/auth/presentation/pages/mobile_login_screen.dart';
import 'package:fix_my_town/features/auth/presentation/state/auth_state.dart';
import 'package:fix_my_town/features/auth/presentation/view_model/auth_viewmodel.dart';

class FakeAuthViewModel extends AuthViewmodel {
  @override
  AuthState build() {
    return AuthState(status: AuthStatus.initial);
  }
}

void main() {
  testWidgets("Should have input fields", (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authViewmodelProvider.overrideWith(FakeAuthViewModel.new)],
        child: const MaterialApp(home: MobileLoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    Finder emailField = find.byType(MyTextFormFieldLogin).at(0);
    Finder passwordField = find.byType(MyTextFormFieldLogin).at(1);

    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
  });

  testWidgets("Should have Login button", (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authViewmodelProvider.overrideWith(FakeAuthViewModel.new)],
        child: const MaterialApp(home: MobileLoginScreen()),
      ),
    );
    await tester.pumpAndSettle();

    Finder loginButton = find.widgetWithText(ElevatedButton, "Login");
    expect(loginButton, findsOneWidget);
  });
}
