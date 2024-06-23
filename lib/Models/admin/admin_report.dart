class Report {
  final int id;
  final int reporterId;
  final String reporter;
  final int reportedCaseId;
  final String reportedCaseName;
  final String caseType;
  final String type;
  final String timestamp;
  final String status;
  Report(
      {required this.id,
      required this.reporter,
      required this.reporterId,
      required this.reportedCaseId,
      required this.reportedCaseName,
      required this.caseType,
      required this.type,
      required this.timestamp,
      required this.status});
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      reporter: json['reporter'],
      reporterId: json['reporterId'],
      reportedCaseId: json['reportedCaseId'],
      reportedCaseName: json['reportedCaseName'],
      caseType: json['caseType'],
      type: json['type'],
      timestamp: json['timestamp'],
      status: json['status'],
    );
  }
}
