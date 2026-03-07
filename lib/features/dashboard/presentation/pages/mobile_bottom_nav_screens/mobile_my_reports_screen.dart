// mobile_my_reports_screen.dart
import 'package:fix_my_town/core/api/api_client.dart';
import 'package:fix_my_town/core/api/api_endpoints.dart';
import 'package:fix_my_town/core/widgets/my_issue_card.dart';
import 'package:fix_my_town/core/widgets/my_issue_count_card.dart';
import 'package:fix_my_town/features/dashboard/data/models/report_stats.model.dart';
import 'package:fix_my_town/features/issues/data/models/issues_api_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileMyReportsScreen extends ConsumerStatefulWidget {
  const MobileMyReportsScreen({super.key});

  @override
  ConsumerState<MobileMyReportsScreen> createState() =>
      _MobileMyReportsScreenState();
}

class _MobileMyReportsScreenState extends ConsumerState<MobileMyReportsScreen> {
  List<IssuesApiModel> _myIssues = [];
  ReportStatsModel? _stats;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final apiClient = ref.read(apiClientProvider);

      final results = await Future.wait([
        apiClient.get(ApiEndpoints.myIssues),
        apiClient.get(ApiEndpoints.reportStats),
      ]);

      final issuesResponse = results[0];
      final statsResponse = results[1];

      setState(() {
        if (issuesResponse.data['success'] == true) {
          final data = issuesResponse.data['data'] as List;
          _myIssues = data
              .map((json) => IssuesApiModel.fromJson(json))
              .toList();
        }
        if (statsResponse.data['success'] == true) {
          _stats = ReportStatsModel.fromJson(statsResponse.data['data']);
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final statsCards = [
      {"count": "${_stats?.totalReports ?? 0}", "title": "Total Reports"},
      {"count": "${_stats?.resolvedReports ?? 0}", "title": "Resolved"},
      {"count": "${_stats?.pendingReports ?? 0}", "title": "Pending"},
      {"count": "${_stats?.inprogressReports ?? 0}", "title": "In Progress"},
    ];

    return SafeArea(
      child: RefreshIndicator(
        color: const Color(0xFF1EA095),
        onRefresh: _fetchData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ───────────────────────────────────────────────
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Text(
                  'My Reports',
                  style: TextStyle(
                    fontFamily: 'Roboto Bold',
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),

              // ── Stats Grid ────────────────────────────────────────────
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(color: Color(0xFF1EA095)),
                  ),
                )
              else ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const spacing = 12.0;
                      const crossAxisCount = 2;
                      final cardWidth =
                          (constraints.maxWidth - spacing) / crossAxisCount;
                      final rows = (statsCards.length / crossAxisCount).ceil();
                      final gridHeight =
                          (rows * (cardWidth * 0.7)) + ((rows - 1) * spacing);

                      return SizedBox(
                        height: gridHeight,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: spacing,
                                mainAxisSpacing: spacing,
                                childAspectRatio: cardWidth / (cardWidth * 0.7),
                              ),
                          itemCount: statsCards.length,
                          itemBuilder: (context, index) =>
                              MyIssueCountCard(myIssue: statsCards[index]),
                        ),
                      );
                    },
                  ),
                ),

                // ── Issues List ─────────────────────────────────────────
                const Padding(
                  padding: EdgeInsets.only(left: 20, top: 20, bottom: 12),
                  child: Text(
                    'My Issues',
                    style: TextStyle(
                      fontFamily: 'Roboto Bold',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),

                if (_error != null)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red[300],
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Failed to load issues',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _fetchData,
                            child: const Text(
                              'Retry',
                              style: TextStyle(color: Color(0xFF1EA095)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (_myIssues.isEmpty)
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
                            "You haven't reported any issues yet",
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
                    itemCount: _myIssues.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final issue = _myIssues[index];
                      final imageUrl = (issue.issueImages?.isNotEmpty == true)
                          ? '${ApiEndpoints.baseUrl}${issue.issueImages!.first}'
                          : '';
                      return MyIssueCard(
                        title: issue.title ?? 'Untitled',
                        address: issue.location ?? 'Unknown location',
                        img: imageUrl,
                        status: issue.status ?? 'open',
                        issueDate: issue.createdAt ?? issue.resolvedAt ?? '',
                        description: issue.description,
                      );
                    },
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
