import 'package:fix_my_town/app/routes/app_routes.dart';
import 'package:fix_my_town/core/api/api_endpoints.dart';
import 'package:fix_my_town/core/services/storage/user_session_service.dart';
import 'package:fix_my_town/core/widgets/my_category_card.dart';
import 'package:fix_my_town/core/widgets/my_issue_card.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_issue_detail_screen.dart';
import 'package:fix_my_town/features/issues/data/models/issues_api_model.dart';
import 'package:fix_my_town/features/issues/presentation/pages/mobile_report_issue_screen.dart';
import 'package:fix_my_town/features/issues/presentation/state/issues_state.dart';
import 'package:fix_my_town/features/issues/presentation/view_model/issues_viewmodel.dart';
import 'package:fix_my_town/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabletHomeScreen extends ConsumerStatefulWidget {
  const TabletHomeScreen({super.key});

  @override
  ConsumerState<TabletHomeScreen> createState() => _TabletHomeScreenState();
}

class _TabletHomeScreenState extends ConsumerState<TabletHomeScreen> {
  static const primary = Color(0xFF1EA095);
  late bool _isAuthority;

  @override
  void initState() {
    super.initState();
    final role =
        ref.read(userSessionServiceProvider).getRole()?.toLowerCase() ?? '';
    _isAuthority = role == 'authority' || role == 'admin';
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (_isAuthority) {
      await ref.read(issuesViewModelProvider.notifier).getMyAssignedIssues();
    } else {
      await ref.read(issuesViewModelProvider.notifier).getMyRecentIssues();
    }
  }

  final List<CategoryModel> _categories = [
    CategoryModel(
      id: 1,
      name: 'Garbage',
      icon: Icons.delete_outline,
      color: const Color(0xFF059669),
      gradient: const [Color(0xFF059669), Color(0xFF047857)],
    ),
    CategoryModel(
      id: 2,
      name: 'Road Damage',
      icon: Icons.report_problem_outlined,
      color: const Color(0xFFDC2626),
      gradient: const [Color(0xFFDC2626), Color(0xFFB91C1C)],
    ),
    CategoryModel(
      id: 3,
      name: 'Street Lights',
      icon: Icons.lightbulb_outline,
      color: const Color(0xFFF59E0B),
      gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
    ),
    CategoryModel(
      id: 4,
      name: 'Water',
      icon: Icons.water_drop_outlined,
      color: const Color(0xFF2563EB),
      gradient: const [Color(0xFF2563EB), Color(0xFF1E40AF)],
    ),
  ];

  Widget _buildIssueCard(IssuesApiModel issue) {
    final imageUrl = (issue.issueImages?.isNotEmpty == true)
        ? '${ApiEndpoints.baseUrl}${issue.issueImages!.first}'
        : '';
    return GestureDetector(
      onTap: () => AppRoutes.push(
        context,
        MobileIssueDetailScreen(issueId: issue.id!, preloaded: issue),
      ),
      child: MyIssueCard(
        title: issue.title ?? 'Untitled',
        address: issue.location ?? 'Unknown location',
        img: imageUrl,
        status: issue.status ?? 'open',
        issueDate: issue.createdAt ?? issue.resolvedAt ?? '',
        description: issue.description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userSession = ref.read(userSessionServiceProvider);
    final firstName = (userSession.getFullname() ?? 'there').split(' ').first;
    final issuesState = ref.watch(issuesViewModelProvider);
    final isLoading = issuesState.status == IssuesStatus.loading;
    final hasError = issuesState.status == IssuesStatus.error;

    final issues = _isAuthority
        ? issuesState.assignedIssues
              .map((e) => IssuesApiModel.fromEntity(e))
              .where(
                (i) => ![
                  'resolved',
                  'rejected',
                  'closed',
                ].contains((i.status ?? '').toLowerCase()),
              )
              .toList()
        : issuesState.recentIssues
              .map((e) => IssuesApiModel.fromEntity(e))
              .toList();

    return SafeArea(
      child: RefreshIndicator(
        color: primary,
        onRefresh: () => _fetchData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 80),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 4),
                    child: Text(
                      'Welcome back, $firstName!',
                      style: const TextStyle(
                        fontFamily: 'Roboto Bold',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24, bottom: 24),
                    child: Text(
                      _isAuthority
                          ? 'Manage your assigned issues'
                          : 'Select a category to report an issue',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 16,
                      ),
                    ),
                  ),

                  if (!_isAuthority)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          const categoryMap = {
                            'Garbage': 'Garbage',
                            'Road Damage': 'Pothole',
                            'Street Lights': 'Broken Streetlight',
                            'Water': 'Water Leakage',
                          };
                          return GestureDetector(
                            onTap: () => AppRoutes.push(
                              context,
                              MobileReportIssueScreen(
                                initialCategory:
                                    categoryMap[category.name] ?? category.name,
                              ),
                            ),
                            child: MyCategoryCard(category: category),
                          );
                        },
                      ),
                    ),

                  Padding(
                    padding: EdgeInsets.only(
                      left: 24,
                      top: _isAuthority ? 8 : 28,
                      bottom: 16,
                      right: 24,
                    ),
                    child: Text(
                      _isAuthority ? 'My Worklist' : 'Recent Activity',
                      style: const TextStyle(
                        fontFamily: 'Roboto Bold',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),

                  if (isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(48),
                        child: CircularProgressIndicator(color: primary),
                      ),
                    )
                  else if (hasError)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red[300],
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isAuthority
                                  ? 'Failed to load worklist'
                                  : 'Failed to load recent activity',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: _fetchData,
                              child: const Text(
                                'Retry',
                                style: TextStyle(color: primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (issues.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: Column(
                          children: [
                            Icon(
                              _isAuthority
                                  ? Icons.assignment_outlined
                                  : Icons.inbox_outlined,
                              color: Colors.grey[300],
                              size: 56,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isAuthority
                                  ? 'No issues assigned to you yet'
                                  : 'No recent activity yet',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 2.8,
                            ),
                        itemCount: issues.length,
                        itemBuilder: (_, i) => _buildIssueCard(issues[i]),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
