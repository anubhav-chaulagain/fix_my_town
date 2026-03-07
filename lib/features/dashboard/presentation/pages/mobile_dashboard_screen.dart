import 'package:fix_my_town/core/services/storage/user_session_service.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_bottom_nav_screens/mobile_all_reports_screen.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_bottom_nav_screens/mobile_home_screen.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_bottom_nav_screens/mobile_my_reports_screen.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_bottom_nav_screens/mobile_profile_screen.dart';
import 'package:fix_my_town/features/issues/presentation/pages/mobile_report_issue_screen.dart';
import 'package:fix_my_town/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileDashboardScreen extends ConsumerStatefulWidget {
  const MobileDashboardScreen({super.key});

  @override
  ConsumerState<MobileDashboardScreen> createState() =>
      _MobileDashboardScreenState();
}

class _MobileDashboardScreenState extends ConsumerState<MobileDashboardScreen> {
  static const primary = Color(0xFF1EA095);

  int _selectedIndex = 0;
  bool _isAuthority = false;

  // Counters per index — incrementing forces screen recreation via ValueKey
  final Map<int, int> _refreshCounters = {0: 0, 1: 0, 2: 0, 3: 0};

  @override
  void initState() {
    super.initState();
    final role =
        ref.read(userSessionServiceProvider).getRole()?.toLowerCase() ?? '';
    _isAuthority = role == 'authority' || role == 'admin';
  }

  List<Widget> get _screens => _isAuthority
      ? [
          MobileHomeScreen(key: ValueKey('home_${_refreshCounters[0]}')),
          MobileAllReportsScreen(key: ValueKey('all_${_refreshCounters[1]}')),
          MobileProfileScreen(key: ValueKey('profile_${_refreshCounters[2]}')),
        ]
      : [
          MobileHomeScreen(key: ValueKey('home_${_refreshCounters[0]}')),
          MobileMyReportsScreen(
            key: ValueKey('myreports_${_refreshCounters[1]}'),
          ),
          MobileAllReportsScreen(key: ValueKey('all_${_refreshCounters[2]}')),
          MobileProfileScreen(key: ValueKey('profile_${_refreshCounters[3]}')),
        ];

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        if (_selectedIndex == index) {
          // Re-tapping current tab → refresh it
          setState(() {
            _refreshCounters[index] = (_refreshCounters[index] ?? 0) + 1;
          });
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? primary : Colors.grey, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? primary : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),

      // ── Bottom Nav ──────────────────────────────────────────────
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 12,
        shadowColor: Colors.black38,
        shape: _isAuthority ? null : const CircularNotchedRectangle(),
        notchMargin: 8,
        height: 75,
        child: _isAuthority
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home_rounded, "Home", 0),
                  _buildNavItem(Icons.bar_chart_rounded, "All Reports", 1),
                  _buildNavItem(Icons.person_rounded, "Profile", 2),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home_rounded, "Home", 0),
                  _buildNavItem(Icons.description_rounded, "My Reports", 1),
                  const Expanded(child: SizedBox()),
                  _buildNavItem(Icons.bar_chart_rounded, "All Reports", 2),
                  _buildNavItem(Icons.person_rounded, "Profile", 3),
                ],
              ),
      ),

      // ── FAB (citizen only) ──────────────────────────────────────
      floatingActionButton: _isAuthority
          ? null
          : PhysicalModel(
              color: Colors.transparent,
              shape: BoxShape.circle,
              shadowColor: primary.withValues(alpha: 0.6),
              elevation: 12,
              child: FloatingActionButton(
                onPressed: () =>
                    AppRoutes.push(context, const MobileReportIssueScreen()),
                backgroundColor: primary,
                shape: const CircleBorder(),
                elevation: 0,
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
