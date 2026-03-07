import 'package:fix_my_town/core/api/api_client.dart';
import 'package:fix_my_town/core/api/api_endpoints.dart';
import 'package:fix_my_town/core/services/storage/user_session_service.dart';
import 'package:fix_my_town/features/issues/data/models/issues_api_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class MobileIssueDetailScreen extends ConsumerStatefulWidget {
  final String issueId;

  // Optionally pass the issue directly to avoid extra fetch
  final IssuesApiModel? preloaded;

  const MobileIssueDetailScreen({
    super.key,
    required this.issueId,
    this.preloaded,
  });

  @override
  ConsumerState<MobileIssueDetailScreen> createState() =>
      _MobileIssueDetailScreenState();
}

class _MobileIssueDetailScreenState
    extends ConsumerState<MobileIssueDetailScreen> {
  static const primary = Color(0xFF1EA095);

  IssuesApiModel? _issue;
  bool _isLoading = true;
  String? _error;

  // For image gallery
  int _currentImageIndex = 0;

  // For status update (authority only)
  bool _isUpdating = false;
  String? _updateError;

  @override
  void initState() {
    super.initState();
    if (widget.preloaded != null) {
      _issue = widget.preloaded;
      _isLoading = false;
    } else {
      _fetchIssue();
    }
  }

  Future<void> _fetchIssue() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.get(
        '${ApiEndpoints.issues}/${widget.issueId}',
      );
      if (response.data['success'] == true) {
        setState(() {
          _issue = _IssueDetailModel.fromDetailJson(response.data['data']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.data['message'] ?? 'Failed to load issue';
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

  Future<void> _updateStatus(String newStatus) async {
    setState(() {
      _isUpdating = true;
      _updateError = null;
    });
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.put(
        '${ApiEndpoints.issues}/${widget.issueId}/status',
        data: {'status': newStatus},
      );
      if (response.data['success'] == true) {
        // Refresh the issue
        await _fetchIssue();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Status updated to ${_formatStatus(newStatus)}'),
              backgroundColor: primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } else {
        setState(() {
          _updateError = response.data['message'] ?? 'Failed to update status';
        });
      }
    } catch (e) {
      setState(() {
        _updateError = e.toString();
      });
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  void _showStatusSheet() {
    const statuses = [
      {'label': 'Open', 'value': 'open'},
      {'label': 'Pending', 'value': 'pending'},
      {'label': 'In Progress', 'value': 'in_progress'},
      {'label': 'Resolved', 'value': 'resolved'},
      {'label': 'Rejected', 'value': 'rejected'},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Update Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            ...statuses.map((s) {
              final isCurrent =
                  (_issue?.status ?? '').toLowerCase() == s['value'];
              final colors = _statusColors(s['value']!);
              return GestureDetector(
                onTap: isCurrent
                    ? null
                    : () {
                        Navigator.pop(ctx);
                        _updateStatus(s['value']!);
                      },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? colors.background
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCurrent
                          ? colors.text.withValues(alpha: 0.4)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        s['label']!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isCurrent
                              ? colors.text
                              : const Color(0xFF374151),
                        ),
                      ),
                      const Spacer(),
                      if (isCurrent)
                        Icon(
                          Icons.check_circle_rounded,
                          color: colors.text,
                          size: 18,
                        ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool isAuthority) {
    final issue = _issue!;
    final images = issue.issueImages ?? [];
    final hasImages = images.isNotEmpty;

    return CustomScrollView(
      slivers: [
        // ── App Bar with image ──────────────────────────────────────
        SliverAppBar(
          expandedHeight: hasImages ? 280 : 120,
          pinned: true,
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: hasImages
                ? Stack(
                    children: [
                      PageView.builder(
                        itemCount: images.length,
                        onPageChanged: (i) =>
                            setState(() => _currentImageIndex = i),
                        itemBuilder: (_, i) => Image.network(
                          '${ApiEndpoints.baseUrl}${images[i]}',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => _ImagePlaceholder(),
                        ),
                      ),
                      // Gradient overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Dots
                      if (images.length > 1)
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              images.length,
                              (i) => AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                width: _currentImageIndex == i ? 20 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _currentImageIndex == i
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                : Container(color: primary),
          ),
        ),

        // ── Content ─────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Title + badges ────────────────────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        issue.title ?? 'Untitled',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _StatusBadge(status: issue.status ?? 'open'),
                        if (issue.priority != null) ...[
                          const SizedBox(height: 6),
                          _PriorityBadge(priority: issue.priority!),
                        ],
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // ── Info cards ────────────────────────────────────
                _InfoCard(
                  children: [
                    _InfoRow(
                      icon: Icons.category_outlined,
                      label: 'Category',
                      value: issue.category ?? '—',
                    ),
                    _Divider(),
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      value: issue.location ?? '—',
                    ),
                    _Divider(),
                    _InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Reported',
                      value: _formatDate(issue.createdAt ?? ''),
                    ),
                    if (issue.resolvedAt != null) ...[
                      _Divider(),
                      _InfoRow(
                        icon: Icons.check_circle_outline,
                        label: 'Resolved',
                        value: _formatDate(issue.resolvedAt!),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 16),

                // ── Description ───────────────────────────────────
                if (issue.description != null &&
                    issue.description!.isNotEmpty) ...[
                  const _SectionTitle(title: 'Description'),
                  const SizedBox(height: 8),
                  _InfoCard(
                    children: [
                      Text(
                        issue.description!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151),
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // ── People ────────────────────────────────────────
                if (issue.reportedByName != null ||
                    issue.assignedToName != null) ...[
                  const _SectionTitle(title: 'People'),
                  const SizedBox(height: 8),
                  _InfoCard(
                    children: [
                      if (issue.reportedByName != null) ...[
                        _PersonRow(
                          icon: Icons.person_outline,
                          label: 'Reported by',
                          name: issue.reportedByName!,
                          email: issue.reportedByEmail,
                        ),
                      ],
                      if (issue.reportedByName != null &&
                          issue.assignedToName != null)
                        _Divider(),
                      if (issue.assignedToName != null)
                        _PersonRow(
                          icon: Icons.assignment_ind_outlined,
                          label: 'Assigned to',
                          name: issue.assignedToName!,
                          email: issue.assignedToEmail,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Remarks ───────────────────────────────────────
                if (issue.remarks != null && issue.remarks!.isNotEmpty) ...[
                  const _SectionTitle(title: 'Remarks'),
                  const SizedBox(height: 8),
                  _InfoCard(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.notes_outlined,
                            size: 16,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              issue.remarks!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF374151),
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Update error ──────────────────────────────────
                if (_updateError != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Color(0xFFDC2626),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _updateError!,
                            style: const TextStyle(
                              color: Color(0xFFDC2626),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // ── Map ───────────────────────────────────────────
                if (issue.latitude != null && issue.longitude != null) ...[
                  const SizedBox(height: 16),
                  const _SectionTitle(title: 'Location on Map'),
                  const SizedBox(height: 8),
                  _ReadOnlyMap(
                    latitude: double.tryParse(issue.latitude!) ?? 0,
                    longitude: double.tryParse(issue.longitude!) ?? 0,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Bottom button for authority ────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final role =
        ref.read(userSessionServiceProvider).getRole()?.toLowerCase() ?? '';
    final isAuthority = role == 'authority' || role == 'admin';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primary))
          : _error != null
          ? _ErrorView(error: _error!, onRetry: _fetchIssue)
          : _buildContent(isAuthority),
      bottomNavigationBar: (!_isLoading && _error == null && isAuthority)
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isUpdating ? null : _showStatusSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: primary.withValues(alpha: 0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: _isUpdating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.edit_outlined, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Update Status',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

// ── Extended model to carry populated fields ──────────────────────────────────

extension _IssueDetailModel on IssuesApiModel {
  static IssuesApiModel fromDetailJson(Map<String, dynamic> json) {
    String? extractId(dynamic val) =>
        val is Map ? val['_id'] as String? : val as String?;
    String? extractName(dynamic val) =>
        val is Map ? val['fullname'] as String? : null;
    String? extractEmail(dynamic val) =>
        val is Map ? val['email'] as String? : null;
    String? extractCategory(dynamic val) =>
        val is Map ? (val['name'] ?? val['_id']) as String? : val as String?;

    return _DetailIssueApiModel(
      id: json['_id'] as String?,
      title: json['title'] as String?,
      category: extractCategory(json['category']),
      location: json['location'] as String?,
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      description: json['description'] as String?,
      issueImages: json['issueImages'] != null
          ? List<String>.from(json['issueImages'])
          : null,
      status: json['status'] as String?,
      priority: json['priority'] as String?,
      reportedBy: extractId(json['reportedBy']),
      assignedTo: extractId(json['assignedTo']),
      resolvedAt: json['resolvedAt'] as String?,
      remarks: json['remarks'] as String?,
      createdAt: json['createdAt'] as String?,
      reportedByName: extractName(json['reportedBy']),
      reportedByEmail: extractEmail(json['reportedBy']),
      assignedToName: extractName(json['assignedTo']),
      assignedToEmail: extractEmail(json['assignedTo']),
    );
  }

  String? get reportedByName => this is _DetailIssueApiModel
      ? (this as _DetailIssueApiModel).reportedByName
      : null;
  String? get reportedByEmail => this is _DetailIssueApiModel
      ? (this as _DetailIssueApiModel).reportedByEmail
      : null;
  String? get assignedToName => this is _DetailIssueApiModel
      ? (this as _DetailIssueApiModel).assignedToName
      : null;
  String? get assignedToEmail => this is _DetailIssueApiModel
      ? (this as _DetailIssueApiModel).assignedToEmail
      : null;
}

class _DetailIssueApiModel extends IssuesApiModel {
  final String? reportedByName;
  final String? reportedByEmail;
  final String? assignedToName;
  final String? assignedToEmail;

  _DetailIssueApiModel({
    super.id,
    super.title,
    super.category,
    super.location,
    super.latitude,
    super.longitude,
    super.description,
    super.issueImages,
    super.status,
    super.priority,
    super.reportedBy,
    super.assignedTo,
    super.resolvedAt,
    super.remarks,
    super.createdAt,
    this.reportedByName,
    this.reportedByEmail,
    this.assignedToName,
    this.assignedToEmail,
  });
}

// ── Helpers ───────────────────────────────────────────────────────────────────

String _formatDate(String raw) {
  if (raw.isEmpty) return '—';
  try {
    final dt = DateTime.parse(raw).toLocal();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  } catch (_) {
    return raw;
  }
}

String _formatStatus(String s) {
  switch (s.toLowerCase()) {
    case 'open':
      return 'Open';
    case 'pending':
      return 'Pending';
    case 'in_progress':
      return 'In Progress';
    case 'resolved':
      return 'Resolved';
    case 'rejected':
      return 'Rejected';
    case 'closed':
      return 'Closed';
    default:
      return s;
  }
}

({Color text, Color background}) _statusColors(String status) {
  switch (status.toLowerCase()) {
    case 'open':
    case 'submitted':
    case 'pending':
      return (
        text: const Color(0xFFB45309),
        background: const Color(0xFFFEF3C7),
      );
    case 'in_progress':
      return (
        text: const Color(0xFF1D4ED8),
        background: const Color(0xFFDBEAFE),
      );
    case 'resolved':
      return (
        text: const Color(0xFF059669),
        background: const Color(0xFFDCFCE7),
      );
    case 'rejected':
    case 'closed':
      return (
        text: const Color(0xFFDC2626),
        background: const Color(0xFFFEE2E2),
      );
    default:
      return (
        text: const Color(0xFF6B7280),
        background: const Color(0xFFF3F4F6),
      );
  }
}

// ── Small reusable widgets ────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final colors = _statusColors(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _formatStatus(status),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colors.text,
        ),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.priority});
  final String priority;

  Color get _color {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFDC2626);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'low':
        return const Color(0xFF059669);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag_outlined, size: 11, color: _color),
          const SizedBox(width: 4),
          Text(
            priority[0].toUpperCase() + priority.substring(1).toLowerCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF9CA3AF)),
        const SizedBox(width: 10),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF0F172A),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _PersonRow extends StatelessWidget {
  const _PersonRow({
    required this.icon,
    required this.label,
    required this.name,
    this.email,
  });
  final IconData icon;
  final String label;
  final String name;
  final String? email;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF1EA095)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (email != null)
                Text(
                  email!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFF0F172A),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1, color: Color(0xFFF1F5F9)),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE2E8F0),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Color(0xFFCBD5E1),
          size: 40,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});
  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red[300], size: 48),
            const SizedBox(height: 12),
            const Text(
              'Failed to load issue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onRetry,
              child: const Text(
                'Retry',
                style: TextStyle(color: Color(0xFF1EA095)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadOnlyMap extends StatelessWidget {
  const _ReadOnlyMap({required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    final point = LatLng(latitude, longitude);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 220,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: point,
            initialZoom: 15,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.fix_my_town.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: point,
                  width: 40,
                  height: 40,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1EA095),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF1EA095,
                              ).withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                      CustomPaint(
                        size: const Size(2, 8),
                        painter: _PinTailPainter(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PinTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      Paint()
        ..color = const Color(0xFF1EA095)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
