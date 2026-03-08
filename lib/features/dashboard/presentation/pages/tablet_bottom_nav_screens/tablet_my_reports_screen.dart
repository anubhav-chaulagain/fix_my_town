import 'package:fix_my_town/app/routes/app_routes.dart';
import 'package:fix_my_town/core/api/api_client.dart';
import 'package:fix_my_town/core/api/api_endpoints.dart';
import 'package:fix_my_town/core/widgets/my_issue_card.dart';
import 'package:fix_my_town/core/widgets/my_issue_count_card.dart';
import 'package:fix_my_town/features/dashboard/data/models/report_stats.model.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_issue_detail_screen.dart';
import 'package:fix_my_town/features/issues/data/models/issues_api_model.dart';
import 'package:fix_my_town/features/issues/presentation/state/issues_state.dart';
import 'package:fix_my_town/features/issues/presentation/view_model/issues_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabletMyReportsScreen extends ConsumerStatefulWidget {
  const TabletMyReportsScreen({super.key});

  @override
  ConsumerState<TabletMyReportsScreen> createState() =>
      _TabletMyReportsScreenState();
}

class _TabletMyReportsScreenState extends ConsumerState<TabletMyReportsScreen> {
  static const primary = Color(0xFF1EA095);
  ReportStatsModel? _stats;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await ref.read(issuesViewModelProvider.notifier).getUserIssues();

    // Stats — online only, fails silently offline
    try {
      final apiClient = ref.read(apiClientProvider);
      final statsResponse = await apiClient.get(ApiEndpoints.reportStats);
      if (statsResponse.data['success'] == true && mounted) {
        setState(() {
          _stats = ReportStatsModel.fromJson(statsResponse.data['data']);
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final issuesState = ref.watch(issuesViewModelProvider);
    final isLoading = issuesState.status == IssuesStatus.loading;
    final hasError = issuesState.status == IssuesStatus.error;

    final myIssues = issuesState.userIssues
        .map((e) => IssuesApiModel.fromEntity(e))
        .toList();

    final statsCards = [
      {"count": "${_stats?.totalReports ?? 0}", "title": "Total Reports"},
      {"count": "${_stats?.resolvedReports ?? 0}", "title": "Resolved"},
      {"count": "${_stats?.pendingReports ?? 0}", "title": "Pending"},
      {"count": "${_stats?.inprogressReports ?? 0}", "title": "In Progress"},
    ];

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
                  // ── Header ───────────────────────────────────────
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 24, 24, 20),
                    child: Text(
                      'My Reports',
                      style: TextStyle(
                        fontFamily: 'Roboto Bold',
                        fontSize: 32,
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
                  else ...[
                    // ── Stats — 4 columns on tablet ───────────────
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
                              childAspectRatio: 1.4,
                            ),
                        itemCount: statsCards.length,
                        itemBuilder: (_, i) =>
                            MyIssueCountCard(myIssue: statsCards[i]),
                      ),
                    ),

                    // ── Issues section header ─────────────────────
                    const Padding(
                      padding: EdgeInsets.only(left: 24, top: 28, bottom: 16),
                      child: Text(
                        'My Issues',
                        style: TextStyle(
                          fontFamily: 'Roboto Bold',
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),

                    if (hasError)
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
                                'Failed to load issues',
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
                    else if (myIssues.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(48),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                color: Colors.grey[300],
                                size: 56,
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
                      // ── 2-column issue grid ───────────────────
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
                          itemCount: myIssues.length,
                          itemBuilder: (_, index) {
                            final issue = myIssues[index];
                            final imageUrl =
                                (issue.issueImages?.isNotEmpty == true)
                                ? '${ApiEndpoints.baseUrl}${issue.issueImages!.first}'
                                : '';
                            return GestureDetector(
                              onTap: () => AppRoutes.push(
                                context,
                                MobileIssueDetailScreen(
                                  issueId: issue.id!,
                                  preloaded: issue,
                                ),
                              ),
                              child: MyIssueCard(
                                title: issue.title ?? 'Untitled',
                                address: issue.location ?? 'Unknown location',
                                img: imageUrl,
                                status: issue.status ?? 'open',
                                issueDate:
                                    issue.createdAt ?? issue.resolvedAt ?? '',
                                description: issue.description,
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
