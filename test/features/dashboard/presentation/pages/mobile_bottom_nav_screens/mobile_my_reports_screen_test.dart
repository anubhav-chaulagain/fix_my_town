import 'dart:async';
import 'package:dio/dio.dart';
import 'package:fix_my_town/core/api/api_client.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_bottom_nav_screens/mobile_my_reports_screen.dart';
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
    return Completer<Response>().future;
  }
}

Widget buildMyReportsScreen() {
  return ProviderScope(
    overrides: [apiClientProvider.overrideWithValue(FakeApiClient())],
    child: const MaterialApp(home: MobileMyReportsScreen()),
  );
}

void main() {
  group("MobileMyReportsScreen", () {
    testWidgets("Should show My Reports title", (tester) async {
      await tester.pumpWidget(buildMyReportsScreen());
      await tester.pump();

      expect(find.text("My Reports"), findsOneWidget);
    });

    testWidgets("Should show loading indicator initially", (tester) async {
      await tester.pumpWidget(buildMyReportsScreen());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets("Should render RefreshIndicator", (tester) async {
      await tester.pumpWidget(buildMyReportsScreen());
      await tester.pump();

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });
  });
}
