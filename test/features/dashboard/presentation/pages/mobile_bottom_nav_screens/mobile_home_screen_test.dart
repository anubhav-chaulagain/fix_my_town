import 'dart:async';
import 'package:dio/dio.dart';
import 'package:fix_my_town/core/api/api_client.dart';
import 'package:fix_my_town/core/services/storage/user_session_service.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_bottom_nav_screens/mobile_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeUserSessionService extends UserSessionService {
  FakeUserSessionService() : super.forTesting();

  @override
  String? getFullname() => "Anubhav Chaulagain";

  @override
  String? getRole() => "citizen";
}

class FakeApiClient extends ApiClient {
  FakeApiClient() : super.forTesting();

  @override
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? option,
  }) {
    return Completer<Response>()
        .future; // hangs forever → keeps _isLoading = true
  }
}

Widget buildHomeScreen() {
  return ProviderScope(
    overrides: [
      userSessionServiceProvider.overrideWithValue(FakeUserSessionService()),
      apiClientProvider.overrideWithValue(FakeApiClient()),
    ],
    child: const MaterialApp(home: MobileHomeScreen()),
  );
}

void main() {
  group("MobileHomeScreen", () {
    testWidgets("Should show welcome message with first name", (tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pump();

      expect(find.text("Welcome back, Anubhav!"), findsOneWidget);
    });

    testWidgets("Should show loading indicator initially", (tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets("Should show RefreshIndicator", (tester) async {
      await tester.pumpWidget(buildHomeScreen());
      await tester.pump();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });
}
