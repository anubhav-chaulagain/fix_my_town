import 'package:fix_my_town/core/api/api_client.dart';
import 'package:fix_my_town/core/api/api_endpoints.dart';
import 'package:fix_my_town/core/widgets/my_issue_card.dart';
import 'package:fix_my_town/features/issues/data/models/issues_api_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Filter constants ─────────────────────────────────────────────────────────

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

// ── Screen ───────────────────────────────────────────────────────────────────

class MobileAllReportsScreen extends ConsumerStatefulWidget {
  const MobileAllReportsScreen({super.key});

  @override
  ConsumerState<MobileAllReportsScreen> createState() =>
      _MobileAllReportsScreenState();
}

class _MobileAllReportsScreenState
    extends ConsumerState<MobileAllReportsScreen> {
  List<IssuesApiModel> _issues = [];
  bool _isLoading = true;
  String? _error;

  // Active filter values sent to backend
  String _activeStatus = '';
  String _activeCategory = '';

  // UI label for chip highlight
  String _selectedStatusLabel = 'All';
  String _selectedCategoryLabel = 'All';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData({String status = '', String category = ''}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final apiClient = ref.read(apiClientProvider);

      // Only send non-empty params — backend ignores missing ones
      final queryParams = <String, dynamic>{};
      if (status.isNotEmpty) queryParams['status'] = status;
      if (category.isNotEmpty) queryParams['category'] = category;

      final response = await apiClient.get(
        ApiEndpoints.issues,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.data['success'] == true) {
        final data = response.data['data'] as List;
        setState(() {
          _issues = data.map((json) => IssuesApiModel.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.data['message'] ?? 'Failed to fetch issues';
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

  void _onStatusSelected(String label, String value) {
    setState(() {
      _selectedStatusLabel = label;
      _activeStatus = value;
    });
    _fetchData(status: value, category: _activeCategory);
  }

  void _onCategorySelected(String label, String value) {
    setState(() {
      _selectedCategoryLabel = label;
      _activeCategory = value;
    });
    _fetchData(status: _activeStatus, category: value);
  }

  void _clearFilters() {
    setState(() {
      _selectedStatusLabel = 'All';
      _selectedCategoryLabel = 'All';
      _activeStatus = '';
      _activeCategory = '';
    });
    _fetchData();
  }

  bool get _hasActiveFilters =>
      _activeStatus.isNotEmpty || _activeCategory.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        color: const Color(0xFF1EA095),
        onRefresh: () =>
            _fetchData(status: _activeStatus, category: _activeCategory),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'All Reports',
                      style: TextStyle(
                        fontFamily: 'Roboto Bold',
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    if (!_isLoading)
                      Row(
                        children: [
                          Text(
                            '${_issues.length} issue${_issues.length == 1 ? '' : 's'}',
                            style: const TextStyle(
                              fontSize: 13,
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
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1EA095),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ── Status Chips ──────────────────────────────────────────
              const _SectionLabel(label: 'Status'),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _statusFilters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = _statusFilters[index];
                    return _FilterChip(
                      label: item['label']!,
                      selected: _selectedStatusLabel == item['label'],
                      onTap: () =>
                          _onStatusSelected(item['label']!, item['value']!),
                    );
                  },
                ),
              ),

              const SizedBox(height: 14),

              // ── Category Chips ────────────────────────────────────────
              const _SectionLabel(label: 'Category'),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _categoryFilters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final item = _categoryFilters[index];
                    return _FilterChip(
                      label: item['label']!,
                      selected: _selectedCategoryLabel == item['label'],
                      onTap: () =>
                          _onCategorySelected(item['label']!, item['value']!),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ── Body ──────────────────────────────────────────────────
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(48),
                    child: CircularProgressIndicator(color: Color(0xFF1EA095)),
                  ),
                )
              else if (_error != null)
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
                          onPressed: () => _fetchData(
                            status: _activeStatus,
                            category: _activeCategory,
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(color: Color(0xFF1EA095)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_issues.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          color: Colors.grey[300],
                          size: 48,
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
                              style: TextStyle(color: Color(0xFF1EA095)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _issues.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final issue = _issues[index];
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
          ),
        ),
      ),
    );
  }
}

// ── Reusable widgets ─────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xFF64748B),
          letterSpacing: 0.4,
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
