import 'package:fix_my_town/core/services/storage/user_session_service.dart';
import 'package:fix_my_town/screens/dashboard_screen.dart';
import 'package:fix_my_town/screens/mobile_screens/mobile_splash_screen.dart';
import 'package:fix_my_town/screens/tablet_screens/tablet_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(userSessionServiceProvider).isLoggedIn();

    if (isLoggedIn) {
      return const DashboardScreen();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth < 500
            ? MobileSplashScreen()
            : TabletSplashScreen();
      },
    );
  }
}
