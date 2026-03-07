import 'package:fix_my_town/app/theme/app_colors.dart';
import 'package:fix_my_town/core/api/api_client.dart';
import 'package:fix_my_town/core/api/api_endpoints.dart';
import 'package:fix_my_town/core/services/storage/user_session_service.dart';
import 'package:fix_my_town/features/auth/presentation/pages/login_screen.dart';
import 'package:fix_my_town/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:fix_my_town/features/auth/presentation/pages/mobile_edit_profile_screen.dart';
import 'package:fix_my_town/features/dashboard/data/models/report_stats.model.dart';
import 'package:fix_my_town/model/account_item_model.dart';
import 'package:fix_my_town/core/widgets/my_account_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void _showLogoutDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Logout',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            ref.read(authViewmodelProvider.notifier).logout();
            Navigator.of(context).pop();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            });
          },
          child: const Text(
            'Logout',
            style: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

class MobileProfileScreen extends ConsumerStatefulWidget {
  const MobileProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MobileProfileScreenState();
}

class _MobileProfileScreenState extends ConsumerState<MobileProfileScreen> {
  ReportStatsModel? _stats;
  bool _isLoadingStats = true;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.get(ApiEndpoints.reportStats);
      if (response.data['success'] == true) {
        setState(() {
          _stats = ReportStatsModel.fromJson(response.data['data']);
          _isLoadingStats = false;
        });
      }
    } catch (_) {
      setState(() => _isLoadingStats = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.read(userSessionServiceProvider);
    final fullName = session.getFullname() ?? 'User';
    final email = session.getUserEmail() ?? '';
    final profileImage = session.getProfileImage();

    final List<AccountItem> accountItems = [
      AccountItem(
        id: 1,
        label: "Edit Profile",
        icon: Icons.person_outline,
        color: const Color(0xFF2563EB),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MobileEditProfileScreen(),
          ),
        ),
      ),
      AccountItem(
        id: 2,
        label: "Notifications",
        icon: Icons.notifications_outlined,
        color: const Color(0xFFF59E0B),
        onPressed: () {},
      ),
      AccountItem(
        id: 3,
        label: "Location Settings",
        icon: Icons.location_on_outlined,
        color: const Color(0xFF059669),
        onPressed: () {},
      ),
    ];

    final List<AccountItem> supportItems = [
      AccountItem(
        id: 4,
        label: "Privacy Policy",
        icon: Icons.shield_outlined,
        color: const Color(0xFF6B7280),
        onPressed: () {},
      ),
      AccountItem(
        id: 5,
        label: "Help & Support",
        icon: Icons.help_outline,
        color: const Color(0xFF6B7280),
        onPressed: () {},
      ),
      AccountItem(
        id: 6,
        label: "Terms of Service",
        icon: Icons.description_outlined,
        color: const Color(0xFF6B7280),
        onPressed: () {},
      ),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Card ──────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .07),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1EA095),
                      image: (profileImage != null && profileImage.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(
                                ApiEndpoints.getImageUrl(profileImage),
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (profileImage == null || profileImage.isEmpty)
                        ? const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 38,
                          )
                        : null,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    fullName,
                    style: const TextStyle(
                      fontFamily: 'Roboto Bold',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 20),

                  // Stats row
                  _isLoadingStats
                      ? const SizedBox(
                          height: 40,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF1EA095),
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(
                              count: '${_stats?.totalReports ?? 0}',
                              label: 'Reports',
                              color: const Color(0xFF1EA095),
                            ),
                            _Divider(),
                            _StatItem(
                              count: '${_stats?.resolvedReports ?? 0}',
                              label: 'Resolved',
                              color: const Color(0xFF059669),
                            ),
                            _Divider(),
                            _StatItem(
                              count: '${_stats?.pendingReports ?? 0}',
                              label: 'Pending',
                              color: const Color(0xFFD97706),
                            ),
                            _Divider(),
                            _StatItem(
                              count: '${_stats?.inprogressReports ?? 0}',
                              label: 'In Progress',
                              color: const Color(0xFF2563EB),
                            ),
                          ],
                        ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Account Section ───────────────────────────────────────
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'ACCOUNT',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            ListView.builder(
              itemCount: accountItems.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, index) =>
                  MyAccountItemCard(item: accountItems[index]),
            ),

            const SizedBox(height: 20),

            // ── Support Section ───────────────────────────────────────
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'SUPPORT',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            ListView.builder(
              itemCount: supportItems.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, index) =>
                  MyAccountItemCard(item: supportItems[index]),
            ),

            const SizedBox(height: 24),

            // ── Logout ────────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                onTap: () => _showLogoutDialog(context, ref),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: const Icon(
                  Icons.logout,
                  size: 20,
                  color: Color(0xFFDC2626),
                ),
                title: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFDC2626),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const _StatItem({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: const Color(0xFFF1F5F9));
  }
}
