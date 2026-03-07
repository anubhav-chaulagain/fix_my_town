// mobile_home_screen.dart
import 'package:fix_my_town/app/routes/app_routes.dart';
import 'package:fix_my_town/core/api/api_client.dart';
import 'package:fix_my_town/core/api/api_endpoints.dart';
import 'package:fix_my_town/core/services/storage/user_session_service.dart';
import 'package:fix_my_town/core/widgets/my_category_card.dart';
import 'package:fix_my_town/core/widgets/my_issue_card.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_issue_detail_screen.dart';
import 'package:fix_my_town/features/issues/data/models/issues_api_model.dart';
import 'package:fix_my_town/features/issues/presentation/pages/mobile_report_issue_screen.dart';
import 'package:fix_my_town/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileHomeScreen extends ConsumerStatefulWidget {
  const MobileHomeScreen({super.key});

  @override
  ConsumerState<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends ConsumerState<MobileHomeScreen> {
  static const primary = Color(0xFF1EA095);

  List<IssuesApiModel> _recentIssues = [];
  List<IssuesApiModel> _assignedIssues = [];
  bool _isLoading = true;
  String? _error;

  // Pagination for authority worklist
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;

  late bool _isAuthority;

  @override
  void initState() {
    super.initState();
    final role =
        ref.read(userSessionServiceProvider).getRole()?.toLowerCase() ?? '';
    _isAuthority = role == 'authority' || role == 'admin';
    _fetchData();
  }

  Future<void> _fetchData({bool reset = true}) async {
    if (reset) {
      setState(() {
        _isLoading = true;
        _error = null;
        _currentPage = 1;
        _assignedIssues = [];
        _recentIssues = [];
      });
    }

    try {
      final apiClient = ref.read(apiClientProvider);

      if (_isAuthority) {
        final response = await apiClient.get(
          ApiEndpoints.myAssignedIssues,
          queryParameters: {'page': '$_currentPage', 'size': '10'},
        );
        if (response.data['success'] == true) {
          final data = response.data['data'] as List;
          final pagination = response.data['pagination'];
          setState(() {
            if (reset) {
              _assignedIssues = data
                  .map((j) => IssuesApiModel.fromJson(j))
                  .where(
                    (i) => ![
                      'resolved',
                      'rejected',
                      'closed',
                    ].contains((i.status ?? '').toLowerCase()),
                  )
                  .toList();
            } else {
              _assignedIssues.addAll(
                data.map((j) => IssuesApiModel.fromJson(j)),
              );
            }
            _totalPages = pagination['totalPages'] ?? 1;
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = response.data['message'] ?? 'Failed to load worklist';
            _isLoading = false;
          });
        }
      } else {
        final response = await apiClient.get(ApiEndpoints.myRecentIssues);
        if (response.data['success'] == true) {
          final data = response.data['data'] as List;
          setState(() {
            _recentIssues = data
                .map((j) => IssuesApiModel.fromJson(j))
                .toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = response.data['message'] ?? 'Failed to load activity';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreAssigned() async {
    if (_isLoadingMore || _currentPage >= _totalPages) return;
    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.get(
        ApiEndpoints.myAssignedIssues,
        queryParameters: {'page': '$_currentPage', 'size': '10'},
      );
      if (response.data['success'] == true) {
        final data = response.data['data'] as List;
        setState(() {
          _assignedIssues.addAll(data.map((j) => IssuesApiModel.fromJson(j)));
        });
      }
    } catch (_) {
      setState(() => _currentPage--); // rollback on error
    } finally {
      setState(() => _isLoadingMore = false);
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
    final fullName = userSession.getFullname() ?? 'there';
    final firstName = fullName.split(' ').first;

    return SafeArea(
      child: RefreshIndicator(
        color: primary,
        onRefresh: () => _fetchData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ───────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Text(
                  'Welcome back, $firstName!',
                  style: const TextStyle(
                    fontFamily: 'Roboto Bold',
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: Text(
                  _isAuthority
                      ? 'Manage your assigned issues'
                      : 'Select a category to report an issue',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                  ),
                ),
              ),

              // ── Categories (citizen only) ─────────────────────────────
              if (!_isAuthority) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const spacing = 12.0;
                      const crossAxisCount = 2;
                      final cardWidth =
                          (constraints.maxWidth - spacing) / crossAxisCount;
                      final rows = (_categories.length / crossAxisCount).ceil();
                      final gridHeight =
                          (rows * cardWidth) + ((rows - 1) * spacing);

                      return SizedBox(
                        height: gridHeight,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: spacing,
                                mainAxisSpacing: spacing,
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
                                      categoryMap[category.name] ??
                                      category.name,
                                ),
                              ),
                              child: MyCategoryCard(category: category),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],

              // ── Section header ────────────────────────────────────────
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  top: _isAuthority ? 8 : 24,
                  bottom: 12,
                  right: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isAuthority ? 'My Worklist' : 'Recent Activity',
                      style: const TextStyle(
                        fontFamily: 'Roboto Bold',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    if (_isAuthority && !_isLoading)
                      _WorklistSummaryBadge(issues: _assignedIssues),
                  ],
                ),
              ),

              // ── Body ─────────────────────────────────────────────────
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(color: primary),
                  ),
                )
              else if (_error != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red[300],
                          size: 40,
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
                          onPressed: () => _fetchData(),
                          child: const Text(
                            'Retry',
                            style: TextStyle(color: primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_isAuthority) ...[
                // ── Authority worklist ──────────────────────────────
                if (_assignedIssues.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.assignment_outlined,
                            color: Colors.grey[300],
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No issues assigned to you yet',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _assignedIssues.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) =>
                        _buildIssueCard(_assignedIssues[index]),
                  ),

                  // Load more button
                  if (_currentPage < _totalPages)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _isLoadingMore ? null : _loadMoreAssigned,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primary,
                            side: const BorderSide(color: primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: _isLoadingMore
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: primary,
                                  ),
                                )
                              : Text(
                                  'Load more  (${_assignedIssues.length} of ${_assignedIssues.length + (_totalPages - _currentPage) * 10})',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                ],
              ] else ...[
                // ── Citizen recent activity ─────────────────────────
                if (_recentIssues.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            color: Colors.grey[300],
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No recent activity yet',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _recentIssues.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) =>
                        _buildIssueCard(_recentIssues[index]),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Small badge showing pending/in-progress count ────────────────────────────

class _WorklistSummaryBadge extends StatelessWidget {
  const _WorklistSummaryBadge({required this.issues});
  final List<IssuesApiModel> issues;

  @override
  Widget build(BuildContext context) {
    final pending = issues
        .where(
          (i) =>
              (i.status ?? '').toLowerCase() == 'pending' ||
              (i.status ?? '').toLowerCase() == 'open',
        )
        .length;
    final inProgress = issues
        .where((i) => (i.status ?? '').toLowerCase() == 'in_progress')
        .length;

    if (pending == 0 && inProgress == 0) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (pending > 0)
          _MiniChip(
            label: '$pending pending',
            color: const Color(0xFFB45309),
            bg: const Color(0xFFFEF3C7),
          ),
        if (pending > 0 && inProgress > 0) const SizedBox(width: 6),
        if (inProgress > 0)
          _MiniChip(
            label: '$inProgress active',
            color: const Color(0xFF1D4ED8),
            bg: const Color(0xFFDBEAFE),
          ),
      ],
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label, required this.color, required this.bg});
  final String label;
  final Color color;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
