import 'dart:convert';

import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Models/admin/admin_post.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Utils/admin_utils.dart';
import 'package:beehub_flutter_app/Widgets/scroll_table.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AdminPosts extends StatefulWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  const AdminPosts({super.key});

  @override
  State<AdminPosts> createState() => _ReportsState();
}

class _ReportsState extends State<AdminPosts> {
  late Future<List<Post>> _posts;

  @override
  initState() {
    _posts = _fetchPosts();
    super.initState();
  }

  Future<List<Post>> _fetchPosts() async {
    var token = await DatabaseProvider().getToken();
    var url = '${AppUrl.adminPath}/posts';
    List<Post> result = [];
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      var parsed = jsonDecode(response.body);
      var jsonResponse = parsed as List;
      print(jsonResponse);
      result = jsonResponse.map((report) => Post.fromJson(report)).toList();
    } catch (e) {
      print(e);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    const columns = [
      "Id",
      "Creator",
      "Timestamp",
      "Reports",
      "Status",
      "Action"
    ];

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Text('Posts', style: AdminPosts.optionStyle),
          FutureBuilder(
              future: _posts,
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
                                DataCell(Text(e.creatorUsername)),
                                DataCell(Text(DateFormat("dd/MM/yyyy hh:mm aaa")
                                    .format(DateTime.parse(e.timestamp)))),
                                DataCell(Wrap(
                                  children:
                                      getMultipleReportType(e.reportTitleList),
                                )),
                                DataCell(_getStatus(e.isBlocked)),
                                const DataCell(Text('delete')),
                              ]))
                          .toList(),
                    )
                  : const Center(child: CircularProgressIndicator.adaptive())),
        ],
      ),
    );
  }

  _getStatus(bool type) {
    switch (type) {
      case true:
        return Badge(
          label: const Text('Blocked'),
          backgroundColor: Colors.grey[400],
        );
      case false:
        return Badge(
          label: const Text('Active'),
          backgroundColor: Colors.green[600],
        );
      default:
        return const Text('');
    }
  }
}
