import 'package:fix_my_town/app/theme/app_colors.dart';
import 'package:fix_my_town/core/api/api_client.dart';
import 'package:fix_my_town/core/api/api_endpoints.dart';
import 'package:fix_my_town/core/services/sensor/gyroscope_service.dart';
import 'package:fix_my_town/core/services/storage/user_session_service.dart';
import 'package:fix_my_town/features/auth/presentation/pages/login_screen.dart';
import 'package:fix_my_town/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:fix_my_town/features/auth/presentation/pages/mobile_edit_profile_screen.dart';
import 'package:fix_my_town/features/dashboard/data/models/report_stats.model.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_about_screen.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_change_password_screen.dart';
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

class _AuthorityStats {
  final int assignedIssues;
  final int completedIssues;
  final String? department;
  final String? phoneNumber;
  final String? employeeId;

  _AuthorityStats({
    required this.assignedIssues,
    required this.completedIssues,
    this.department,
    this.phoneNumber,
    this.employeeId,
  });

  factory _AuthorityStats.fromJson(Map<String, dynamic> json) =>
      _AuthorityStats(
        assignedIssues: json['assignedIssues'] ?? 0,
        completedIssues: json['completedIssues'] ?? 0,
        department: json['department'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        employeeId: json['employeeId'] as String?,
      );
}

class MobileProfileScreen extends ConsumerStatefulWidget {
  const MobileProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MobileProfileScreenState();
}

class _MobileProfileScreenState extends ConsumerState<MobileProfileScreen> {
  static const primary = Color(0xFF1EA095);

  ReportStatsModel? _citizenStats;
  _AuthorityStats? _authorityStats;
  bool _isLoadingStats = true;
  bool _isAuthority = false;

  // Gyroscope
  final GyroscopeScrollService _gyroService = GyroscopeScrollService();

  @override
  void initState() {
    super.initState();
    final role =
        ref.read(userSessionServiceProvider).getRole()?.toLowerCase() ?? '';
    _isAuthority = role == 'authority' || role == 'admin';
    _fetchStats();
    _gyroService.startListening();
  }

  @override
  void dispose() {
    _gyroService.dispose();
    super.dispose();
  }

  Future<void> _fetchStats() async {
    setState(() => _isLoadingStats = true);
    try {
      final apiClient = ref.read(apiClientProvider);
      if (_isAuthority) {
        final response = await apiClient.get(ApiEndpoints.authorityStats);
        if (response.data['success'] == true) {
          setState(() {
            _authorityStats = _AuthorityStats.fromJson(response.data['data']);
          });
        }
      } else {
        final response = await apiClient.get(ApiEndpoints.reportStats);
        if (response.data['success'] == true) {
          setState(() {
            _citizenStats = ReportStatsModel.fromJson(response.data['data']);
          });
        }
      }
    } catch (_) {
    } finally {
      setState(() => _isLoadingStats = false);
    }
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — coming soon'),
        backgroundColor: const Color(0xFF64748B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
          MaterialPageRoute(builder: (_) => const MobileEditProfileScreen()),
        ),
      ),
      AccountItem(
        id: 2,
        label: "Change Password",
        icon: Icons.lock_outline,
        color: const Color(0xFF1EA095),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MobileChangePasswordScreen()),
        ),
      ),
      AccountItem(
        id: 3,
        label: "Notifications",
        icon: Icons.notifications_outlined,
        color: const Color(0xFFF59E0B),
        onPressed: () => _showComingSoon(context, 'Notifications'),
      ),
      AccountItem(
        id: 4,
        label: "Location Settings",
        icon: Icons.location_on_outlined,
        color: const Color(0xFF059669),
        onPressed: () => _showComingSoon(context, 'Location Settings'),
      ),
    ];

    final List<AccountItem> appItems = [
      AccountItem(
        id: 5,
        label: "About Fix My Town",
        icon: Icons.info_outline,
        color: const Color(0xFF6B7280),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MobileAboutScreen()),
        ),
      ),
      AccountItem(
        id: 6,
        label: "Privacy Policy",
        icon: Icons.shield_outlined,
        color: const Color(0xFF6B7280),
        onPressed: () => _showComingSoon(context, 'Privacy Policy'),
      ),
      AccountItem(
        id: 7,
        label: "Help & Support",
        icon: Icons.help_outline,
        color: const Color(0xFF6B7280),
        onPressed: () => _showComingSoon(context, 'Help & Support'),
      ),
      AccountItem(
        id: 8,
        label: "Terms of Service",
        icon: Icons.description_outlined,
        color: const Color(0xFF6B7280),
        onPressed: () => _showComingSoon(context, 'Terms of Service'),
      ),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        controller: _gyroService.scrollController,
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      color: primary,
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

                  // Role badge
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _isAuthority
                          ? const Color(0xFFEDE9FE)
                          : const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _isAuthority ? 'Authority' : 'Citizen',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _isAuthority ? const Color(0xFF7C3AED) : primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 20),

                  // Stats
                  if (_isLoadingStats)
                    const SizedBox(
                      height: 40,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: primary,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  else if (_isAuthority)
                    _AuthorityStatsRow(stats: _authorityStats)
                  else
                    _CitizenStatsRow(stats: _citizenStats),
                ],
              ),
            ),

            if (_isAuthority && _authorityStats != null) ...[
              const SizedBox(height: 16),
              _AuthorityInfoCard(stats: _authorityStats!),
            ],

            const SizedBox(height: 24),

            const _SectionLabel(label: 'ACCOUNT'),
            ListView.builder(
              itemCount: accountItems.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, i) => MyAccountItemCard(item: accountItems[i]),
            ),

            const SizedBox(height: 20),

            const _SectionLabel(label: 'APP'),
            ListView.builder(
              itemCount: appItems.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, i) => MyAccountItemCard(item: appItems[i]),
            ),

            const SizedBox(height: 24),

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

class _CitizenStatsRow extends StatelessWidget {
  const _CitizenStatsRow({this.stats});
  final ReportStatsModel? stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem(
          count: '${stats?.totalReports ?? 0}',
          label: 'Reports',
          color: const Color(0xFF1EA095),
        ),
        _VerticalDivider(),
        _StatItem(
          count: '${stats?.resolvedReports ?? 0}',
          label: 'Resolved',
          color: const Color(0xFF059669),
        ),
        _VerticalDivider(),
        _StatItem(
          count: '${stats?.pendingReports ?? 0}',
          label: 'Pending',
          color: const Color(0xFFD97706),
        ),
        _VerticalDivider(),
        _StatItem(
          count: '${stats?.inprogressReports ?? 0}',
          label: 'In Progress',
          color: const Color(0xFF2563EB),
        ),
      ],
    );
  }
}

class _AuthorityStatsRow extends StatelessWidget {
  const _AuthorityStatsRow({this.stats});
  final _AuthorityStats? stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _StatItem(
          count: '${stats?.assignedIssues ?? 0}',
          label: 'Assigned',
          color: const Color(0xFF1EA095),
        ),
        _VerticalDivider(),
        _StatItem(
          count: '${stats?.completedIssues ?? 0}',
          label: 'Completed',
          color: const Color(0xFF059669),
        ),
      ],
    );
  }
}

class _AuthorityInfoCard extends StatelessWidget {
  const _AuthorityInfoCard({required this.stats});
  final _AuthorityStats stats;

  @override
  Widget build(BuildContext context) {
    final rows = <_InfoEntry>[
      if (stats.department != null)
        _InfoEntry(Icons.business_outlined, 'Department', stats.department!),
      if (stats.employeeId != null)
        _InfoEntry(Icons.badge_outlined, 'Employee ID', stats.employeeId!),
      if (stats.phoneNumber != null)
        _InfoEntry(Icons.phone_outlined, 'Phone', stats.phoneNumber!),
    ];

    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Work Details',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 12),
          ...rows.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      e.icon,
                      size: 16,
                      color: const Color(0xFF1EA095),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.label,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      Text(
                        e.value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoEntry {
  final IconData icon;
  final String label;
  final String value;
  const _InfoEntry(this.icon, this.label, this.value);
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.count,
    required this.label,
    required this.color,
  });
  final String count;
  final String label;
  final Color color;

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

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 32, color: const Color(0xFFF1F5F9));
}
