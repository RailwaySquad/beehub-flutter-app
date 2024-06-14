import 'dart:convert';

import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Screens/Administrator/group_info.dart';
import 'package:beehub_flutter_app/Screens/Administrator/user_info.dart';
import 'package:beehub_flutter_app/Utils/page_navigator.dart';
import 'package:beehub_flutter_app/Widgets/scroll_table.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Reports extends StatefulWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  late Future<List<Report>> _reports;

  @override
  initState() {
    _reports = _fetchReports();
    super.initState();
  }

  Future<List<Report>> _fetchReports() async {
    var token = await DatabaseProvider().getToken();
    var url = '${AppUrl.adminPath}/reports';
    List<Report> result = [];
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      var parsed = jsonDecode(response.body);
      var jsonResponse = parsed as List;
      result = jsonResponse.map((report) => Report.fromJson(report)).toList();
    } catch (e) {
      print(e);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    const columns = [
      "Id",
      "Reporter",
      "Case",
      "Type",
      "Timestamp",
      "Status",
      "Action"
    ];

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Text('Reports', style: Reports.optionStyle),
          FutureBuilder(
              future: _reports,
              builder: (context, snapshot) => snapshot.hasData
                  ? ScrollTable(
                      columns: columns
                          .map((e) => DataColumn(
                                  label: Text(
                                e,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              )))
                          .toList(),
                      rows: snapshot.data!
                          .map((e) => DataRow(cells: [
                                DataCell(Text(e.id.toString())),
                                DataCell(InkWell(
                                    onTap: () => PageNavigator(ctx: context)
                                        .nextPage(
                                            page: UserInfo(id: e.reporterId)),
                                    child: Text(
                                      e.reporter,
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ))),
                                DataCell(Row(
                                  children: [
                                    Text('${e.caseType}: '),
                                    InkWell(
                                      onTap: () {
                                        if (e.caseType == 'user') {
                                          PageNavigator(ctx: context).nextPage(
                                              page: UserInfo(
                                                  id: e.reportedCaseId));
                                        } else if (e.caseType == 'group') {
                                          PageNavigator(ctx: context).nextPage(
                                              page: GroupInfo(
                                                  id: e.reportedCaseId));
                                        }
                                      },
                                      child: Text(e.reportedCaseName,
                                          style: const TextStyle(
                                              color: Colors.blue)),
                                    )
                                  ],
                                )),
                                DataCell(_getType(e.type)),
                                DataCell(Text(DateFormat.yMd()
                                    .add_jm()
                                    .format(DateTime.parse(e.timestamp)))),
                                DataCell(_getStatus(e.status)),
                                const DataCell(Text('delete')),
                              ]))
                          .toList(),
                    )
                  : const Center(child: CircularProgressIndicator.adaptive())),
        ],
      ),
    );
  }

  _getType(String type) {
    switch (type) {
      case 'nudity':
      case 'spam':
        return Badge(
          label: Text(type),
          backgroundColor: Colors.yellow[900],
        );
      case 'violence':
      case 'involve a child':
      case 'drugs':
        return Badge(
          label: Text(type),
          backgroundColor: Colors.red,
        );
      default:
        return Badge(
          label: Text(type),
          backgroundColor: Colors.grey,
        );
    }
  }

  _getStatus(String status) {
    switch (status) {
      case 'active':
        return Badge(
          label: Text(status),
          backgroundColor: Colors.green,
        );
      case 'inactive':
        return Badge(
          label: Text(status),
          backgroundColor: Colors.red,
        );
      case 'blocked':
      default:
        return Badge(
          label: Text(status),
          backgroundColor: Colors.grey,
        );
    }
  }
}

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
