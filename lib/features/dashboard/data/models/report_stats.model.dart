// report_stats_model.dart
class ReportStatsModel {
  final int totalReports;
  final int pendingReports;
  final int resolvedReports;
  final int inprogressReports;

  ReportStatsModel({
    this.totalReports = 0,
    this.pendingReports = 0,
    this.resolvedReports = 0,
    this.inprogressReports = 0,
  });

  factory ReportStatsModel.fromJson(Map<String, dynamic> json) {
    return ReportStatsModel(
      totalReports: (json['totalReports'] ?? 0) as int,
      pendingReports: (json['pendingReports'] ?? 0) as int,
      resolvedReports: (json['resolvedReports'] ?? 0) as int,
      inprogressReports: (json['inprogressReports'] ?? 0) as int,
    );
  }
}
