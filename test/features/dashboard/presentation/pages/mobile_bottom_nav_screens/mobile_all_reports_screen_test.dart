import 'dart:async';
import 'package:dio/dio.dart';
import 'package:fix_my_town/core/api/api_client.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_bottom_nav_screens/mobile_all_reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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

Widget buildAllReportsScreen() {
  return ProviderScope(
    overrides: [apiClientProvider.overrideWithValue(FakeApiClient())],
    child: const MaterialApp(home: MobileAllReportsScreen()),
  );
}

void main() {
  group("MobileAllReportsScreen", () {
    testWidgets("Should show All Reports title", (tester) async {
      await tester.pumpWidget(buildAllReportsScreen());
      await tester.pump();

      expect(find.text("All Reports"), findsOneWidget);
    });

    testWidgets("Should show loading indicator initially", (tester) async {
      await tester.pumpWidget(buildAllReportsScreen());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets("Should show Status section label", (tester) async {
      await tester.pumpWidget(buildAllReportsScreen());
      await tester.pump();

      expect(find.text("Status"), findsOneWidget);
    });

    testWidgets("Should show Category section label", (tester) async {
      await tester.pumpWidget(buildAllReportsScreen());
      await tester.pump();

      expect(find.text("Category"), findsOneWidget);
    });
  });
}
