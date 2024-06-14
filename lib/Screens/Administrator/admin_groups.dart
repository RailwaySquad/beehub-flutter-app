import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Widgets/scroll_table.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminGroups extends StatefulWidget {
  static const TextStyle optionStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  const AdminGroups({super.key});

  @override
  State<AdminGroups> createState() => _ReportsState();
}

class _ReportsState extends State<AdminGroups> {
  late Future<List<Group>> _groups;

  @override
  initState() {
    _groups = _fetchGroups();
    super.initState();
  }

  Future<List<Group>> _fetchGroups() async {
    var token = await DatabaseProvider().getToken();
    var url = '${AppUrl.adminPath}/groups';
    List<Group> result = [];
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      var parsed = jsonDecode(response.body);
      var jsonResponse = parsed as List;
      result = jsonResponse.map((report) => Group.fromJson(report)).toList();
    } catch (e) {
      print(e);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    const columns = [
      "Id",
      "Group Name",
      "Visibility",
      "Created At",
      "Total members",
      "Status",
      "Action"
    ];

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Text('Groups', style: AdminGroups.optionStyle),
          FutureBuilder(
              future: _groups,
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
                                DataCell(Text(e.groupName)),
                                DataCell(Text(e.isPublic ? 'Public' : 'Private')),
                                DataCell(Text(DateFormat.yMd()
                                        .add_jm()
                                        .format(DateTime.parse(e.createdAt)))),
                                DataCell(Text(e.memberCount.toString())),
                                DataCell(_getStatus(e.active)),
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
          label: const Text('Active'),
          backgroundColor: Colors.green[600],
        );
      case false:
        return Badge(
          label: const Text('Inactive'),
          backgroundColor: Colors.red[400],
        );
      default:
        return const Text('');
    }
  }
}

class Group {
  final int id;
  final String groupName;
  final bool isPublic;
  final bool active;
  final int memberCount;
  final String createdAt;
  Group(
      {required this.id,
      required this.groupName,
      required this.isPublic,
      required this.active,
      required this.memberCount,
      required this.createdAt});
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      groupName: json['groupname'],
      isPublic: json['public_group'],
      active: json['active'],
      memberCount: json['member_count'],
      createdAt: json['created_at'],
    );
  }
}