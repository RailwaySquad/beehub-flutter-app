import 'dart:convert';

import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
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
    var columns = ["Id", "Reporter", "Case", "Type", "Timestamp", "Status", "Action"];

    return Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text(
              'Reports',
              style: Reports.optionStyle,
            ),
            FutureBuilder(
                future: _reports,
                builder: (context, snapshot) => snapshot.hasData
                    ? Scrollbar(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
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
                                        InkWell(
                                          onTap: (){},
                                          child: Text(e.reporter, style: const TextStyle(color: Colors.blue),)
                                        )
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            Text('${e.caseType}: '),
                                            InkWell(
                                              onTap: (){},
                                              child: Text(e.reportedCase, style: const TextStyle(color: Colors.blue)),
                                            )
                                          ],
                                        )
                                      ),
                                      DataCell(_getType(e.type)),
                                      DataCell(Text(DateFormat.yMd()
                                          .add_jm()
                                          .format(
                                              DateTime.parse(e.timestamp)))),
                                      DataCell(Text(e.status)),
                                      const DataCell(Text('delete')),
                                    ]))
                                .toList(),
                          ),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator.adaptive())),
          ],
        ));
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
}

class Report {
  final int id;
  final String reporter;
  final String reportedCase;
  final String caseType;
  final String type;
  final String timestamp;
  final String status;
  Report(
      {required this.id,
      required this.reporter,
      required this.reportedCase,
      required this.caseType,
      required this.type,
      required this.timestamp,
      required this.status});
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      reporter: json['reporter'],
      reportedCase: json['reportedCase'],
      caseType: json['caseType'],
      type: json['type'],
      timestamp: json['timestamp'],
      status: json['status'],
    );
  }
}
