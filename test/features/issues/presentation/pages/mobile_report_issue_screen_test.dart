import 'package:fix_my_town/features/issues/presentation/pages/mobile_report_issue_screen.dart';
import 'package:fix_my_town/features/issues/presentation/state/issues_state.dart';
import 'package:fix_my_town/features/issues/presentation/view_model/issues_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeIssuesViewModel extends IssuesViewModel {
  @override
  IssuesState build() => const IssuesState();
}

class FakeIssuesViewModelLoading extends IssuesViewModel {
  @override
  IssuesState build() => const IssuesState(status: IssuesStatus.loading);
}

Widget buildReportScreen({IssuesViewModel? vm}) {
  return ProviderScope(
    overrides: [
      issuesViewModelProvider.overrideWith(() => vm ?? FakeIssuesViewModel()),
    ],
    child: const MaterialApp(home: MobileReportIssueScreen()),
  );
}

void main() {
  group("MobileReportIssueScreen", () {
    testWidgets("Should show Report Issue in app bar", (tester) async {
      await tester.pumpWidget(buildReportScreen());
      await tester.pumpAndSettle();

      expect(find.text("Report Issue"), findsOneWidget);
    });

    testWidgets("Should have title input field", (tester) async {
      await tester.pumpWidget(buildReportScreen());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(TextFormField, "e.g. Large pothole blocking lane"),
        findsOneWidget,
      );
    });

    testWidgets("Should have Submit Report button", (tester) async {
      await tester.pumpWidget(buildReportScreen());
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(ElevatedButton, "Submit Report"),
        findsOneWidget,
      );
    });

    testWidgets("Should show CircularProgressIndicator when loading", (
      tester,
    ) async {
      await tester.pumpWidget(
        buildReportScreen(vm: FakeIssuesViewModelLoading()),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets("Should show Tap to add photos area", (tester) async {
      await tester.pumpWidget(buildReportScreen());
      await tester.pumpAndSettle();

      expect(find.text("Tap to add photos"), findsOneWidget);
    });
  });
}
