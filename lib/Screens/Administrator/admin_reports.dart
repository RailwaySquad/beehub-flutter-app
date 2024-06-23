import 'dart:convert';

import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Utils/admin_utils.dart';
import 'package:beehub_flutter_app/Widgets/admin/group_info.dart';
import 'package:beehub_flutter_app/Models/admin/admin_report.dart';
import 'package:beehub_flutter_app/Widgets/admin/post_info.dart';
import 'package:beehub_flutter_app/Widgets/admin/user_info.dart';
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
                                DataCell(
                                    Text(
                                      e.reporter,
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                    onTap: () => PageNavigator(ctx: context)
                                        .nextPage(
                                            page: UserInfo(id: e.reporterId))),
                                DataCell(
                                    Row(
                                      children: [
                                        Text('${e.caseType}: '),
                                        Text(e.reportedCaseName,
                                            style: const TextStyle(
                                                color: Colors.blue))
                                      ],
                                    ), onTap: () {
                                  if (e.caseType == 'user') {
                                    PageNavigator(ctx: context).nextPage(
                                        page: UserInfo(id: e.reportedCaseId));
                                  } else if (e.caseType == 'group') {
                                    PageNavigator(ctx: context).nextPage(
                                        page: GroupInfo(id: e.reportedCaseId));
                                  } else if (e.caseType == 'post') {
                                    PageNavigator(ctx: context).nextPage(
                                        page: PostInfo(id: e.reportedCaseId));
                                  }
                                }),
                                DataCell(getReportType(e.type, null)),
                                DataCell(Text(DateFormat("dd/MM/yyyy hh:mm aaa")
                                    .format(DateTime.parse(e.timestamp)))),
                                DataCell(getStatus(e.status)),
                                const DataCell(Text('delete')),
                              ]))
                          .toList(),
                    )
                  : const Center(child: CircularProgressIndicator.adaptive())),
        ],
      ),
    );
  }
}
