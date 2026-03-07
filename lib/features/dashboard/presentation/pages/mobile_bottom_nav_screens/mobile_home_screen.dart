// mobile_home_screen.dart
import 'package:fix_my_town/core/api/api_client.dart';
import 'package:fix_my_town/core/api/api_endpoints.dart';
import 'package:fix_my_town/core/services/storage/user_session_service.dart';
import 'package:fix_my_town/core/widgets/my_category_card.dart';
import 'package:fix_my_town/core/widgets/my_issue_card.dart';
import 'package:fix_my_town/features/issues/data/models/issues_api_model.dart';
import 'package:fix_my_town/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileHomeScreen extends ConsumerStatefulWidget {
  const MobileHomeScreen({super.key});

  @override
  ConsumerState<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends ConsumerState<MobileHomeScreen> {
  List<IssuesApiModel> _recentIssues = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchRecentIssues();
  }

  Future<void> _fetchRecentIssues() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.get(ApiEndpoints.myRecentIssues);
      if (response.data['success'] == true) {
        final data = response.data['data'] as List;
        setState(() {
          _recentIssues = data
              .map((json) => IssuesApiModel.fromJson(json))
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    final userSession = ref.read(userSessionServiceProvider);
    final fullName = userSession.getFullname() ?? 'there';
    final firstName = fullName.split(' ').first;

    return SafeArea(
      child: RefreshIndicator(
        color: const Color(0xFF1EA095),
        onRefresh: _fetchRecentIssues,
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
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 20),
                child: Text(
                  'Select a category to report an issue',
                  style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                ),
              ),

              // ── Categories ───────────────────────────────────────────
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
                        itemBuilder: (context, index) =>
                            MyCategoryCard(category: _categories[index]),
                      ),
                    );
                  },
                ),
              ),

              // ── Recent Activity ───────────────────────────────────────
              const Padding(
                padding: EdgeInsets.only(left: 20, top: 24, bottom: 12),
                child: Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontFamily: 'Roboto Bold',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),

              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(color: Color(0xFF1EA095)),
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
                          'Failed to load recent activity',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _fetchRecentIssues,
                          child: const Text(
                            'Retry',
                            style: TextStyle(color: Color(0xFF1EA095)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_recentIssues.isEmpty)
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
                  itemBuilder: (context, index) {
                    final issue = _recentIssues[index];
                    final imageUrl = (issue.issueImages?.isNotEmpty == true)
                        ? '${ApiEndpoints.baseUrl}${issue.issueImages!.first}'
                        : '';
                    return MyIssueCard(
                      title: issue.title ?? 'Untitled',
                      address: issue.location ?? 'Unknown location',
                      img: imageUrl,
                      status: issue.status ?? 'open',
                      issueDate: issue.resolvedAt ?? '',
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
