import 'package:fix_my_town/app/routes/app_routes.dart';
import 'package:fix_my_town/core/api/api_endpoints.dart';
import 'package:fix_my_town/core/widgets/my_issue_card.dart';
import 'package:fix_my_town/features/dashboard/presentation/pages/mobile_issue_detail_screen.dart';
import 'package:fix_my_town/features/issues/data/models/issues_api_model.dart';
import 'package:fix_my_town/features/issues/presentation/state/issues_state.dart';
import 'package:fix_my_town/features/issues/presentation/view_model/issues_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _statusFilters = <Map<String, String>>[
  {'label': 'All', 'value': ''},
  {'label': 'Open', 'value': 'open'},
  {'label': 'Pending', 'value': 'pending'},
  {'label': 'In Progress', 'value': 'in_progress'},
  {'label': 'Resolved', 'value': 'resolved'},
  {'label': 'Rejected', 'value': 'rejected'},
];

const _categoryFilters = <Map<String, String>>[
  {'label': 'All', 'value': ''},
  {'label': 'Garbage', 'value': 'Garbage'},
  {'label': 'Pothole', 'value': 'Pothole'},
  {'label': 'Broken Streetlight', 'value': 'Broken Streetlight'},
  {'label': 'Water Leakage', 'value': 'Water Leakage'},
];

class TabletAllReportsScreen extends ConsumerStatefulWidget {
  const TabletAllReportsScreen({super.key});

  @override
  ConsumerState<TabletAllReportsScreen> createState() =>
      _TabletAllReportsScreenState();
}

class _TabletAllReportsScreenState
    extends ConsumerState<TabletAllReportsScreen> {
  static const primary = Color(0xFF1EA095);

  String _activeStatus = '';
  String _activeCategory = '';
  String _selectedStatusLabel = 'All';
  String _selectedCategoryLabel = 'All';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await ref.read(issuesViewModelProvider.notifier).getAllIssues();
  }

  void _onStatusSelected(String label, String value) {
    setState(() {
      _selectedStatusLabel = label;
      _activeStatus = value;
    });
  }

  void _onCategorySelected(String label, String value) {
    setState(() {
      _selectedCategoryLabel = label;
      _activeCategory = value;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedStatusLabel = 'All';
      _selectedCategoryLabel = 'All';
      _activeStatus = '';
      _activeCategory = '';
    });
  }

  bool get _hasActiveFilters =>
      _activeStatus.isNotEmpty || _activeCategory.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final issuesState = ref.watch(issuesViewModelProvider);
    final isLoading = issuesState.status == IssuesStatus.loading;
    final hasError = issuesState.status == IssuesStatus.error;

    // Client-side filtering
    var issues = issuesState.issues
        .map((e) => IssuesApiModel.fromEntity(e))
        .toList();
    if (_activeStatus.isNotEmpty) {
      issues = issues
          .where(
            (i) =>
                (i.status ?? '').toLowerCase() == _activeStatus.toLowerCase(),
          )
          .toList();
    }
    if (_activeCategory.isNotEmpty) {
      issues = issues
          .where(
            (i) =>
                (i.category ?? '').toLowerCase() ==
                _activeCategory.toLowerCase(),
          )
          .toList();
    }

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
                  // ── Header ─────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'All Reports',
                          style: TextStyle(
                            fontFamily: 'Roboto Bold',
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        if (!isLoading)
                          Row(
                            children: [
                              Text(
                                '${issues.length} issue${issues.length == 1 ? '' : 's'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              if (_hasActiveFilters) ...[
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: _clearFilters,
                                  child: const Text(
                                    'Clear',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: primary,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Filters side by side on tablet ─────────────
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status filters
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                  letterSpacing: 0.4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _statusFilters.map((item) {
                                  return _FilterChip(
                                    label: item['label']!,
                                    selected:
                                        _selectedStatusLabel == item['label'],
                                    onTap: () => _onStatusSelected(
                                      item['label']!,
                                      item['value']!,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Category filters
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Category',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF64748B),
                                  letterSpacing: 0.4,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _categoryFilters.map((item) {
                                  return _FilterChip(
                                    label: item['label']!,
                                    selected:
                                        _selectedCategoryLabel == item['label'],
                                    onTap: () => _onCategorySelected(
                                      item['label']!,
                                      item['value']!,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Body ───────────────────────────────────────
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
                  else if (issues.isEmpty)
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
                              'No issues found',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            if (_hasActiveFilters) ...[
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: _clearFilters,
                                child: const Text(
                                  'Clear filters',
                                  style: TextStyle(color: primary),
                                ),
                              ),
                            ],
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
                        itemBuilder: (_, index) {
                          final issue = issues[index];
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1EA095) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF1EA095) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}
