import 'dart:convert';

import 'package:beehub_flutter_app/Models/admin/admin_user.dart';
import 'package:beehub_flutter_app/Utils/admin_utils.dart';
import 'package:http/http.dart' as http;
import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Widgets/scroll_table.dart';
import 'package:flutter/material.dart';

class AdminUsers extends StatefulWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _ReportsState();
}

class _ReportsState extends State<AdminUsers> {
  late Future<List<User>> _users;

  @override
  initState() {
    _users = _fetchUsers();
    super.initState();
  }

  Future<List<User>> _fetchUsers() async {
    var token = await DatabaseProvider().getToken();
    var url = '${AppUrl.adminPath}/users';
    List<User> result = [];
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      var parsed = jsonDecode(response.body);
      var jsonResponse = parsed as List;
      result = jsonResponse.map((report) => User.fromJson(report)).toList();
    } catch (e) {
      print(e);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    const columns = [
      "Id",
      "Username",
      "Email",
      "Gender",
      "No Of Posts",
      "No Of Friends",
      "Reports",
      "Role",
      "Status",
      "Action"
    ];

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Text('Users', style: AdminUsers.optionStyle),
          FutureBuilder(
              future: _users,
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
                                      e.username,
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ),
                                    onTap: () {}),
                                DataCell(Text(e.email)),
                                DataCell(getGender(e.gender)),
                                DataCell(Text(e.noOfPosts.toString())),
                                DataCell(Text(e.noOfFriends.toString())),
                                DataCell(
                                  Wrap(
                                    children: getMultipleReportType(e.reportTitleList),
                                  )
                                ), // role
                                DataCell(getRole(e.role)),
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
