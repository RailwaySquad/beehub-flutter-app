import 'dart:convert';

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
      "Full Name",
      "Gender",
      "No Of Posts",
      "No Of Friends",
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
                                DataCell(InkWell(
                                    onTap: () {},
                                    child: Text(
                                      e.username,
                                      style:
                                          const TextStyle(color: Colors.blue),
                                    ))),
                                DataCell(Text(e.email)),
                                DataCell(Text(e.fullName)),
                                DataCell(_getGender(e.gender)),
                                DataCell(Text(e.noOfPosts.toString())),
                                DataCell(Text(e.noOfFriends.toString())),
                                DataCell(_getRole(e.role)),
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

  _getGender(String type) {
    switch (type) {
      case 'male':
        return Icon(
          Icons.male,
          color: Colors.blue[900],
        );
      case 'female':
        return Icon(
          Icons.female,
          color: Colors.red[600],
        );
      default:
        return Text(type);
    }
  }

  _getRole(String type) {
    switch (type) {
      case 'ROLE_ADMIN':
        return Badge(
          label: const Text('Admin'),
          backgroundColor: Colors.blue[600],
        );
      case 'ROLE_USER':
        return Badge(
          label: const Text('User'),
          backgroundColor: Colors.grey[400],
        );
      default:
        return Text(type);
    }
  }

  _getStatus(String type) {
    switch (type) {
      case 'active':
        return Badge(
          label: const Text('Active'),
          backgroundColor: Colors.green[600],
        );
      case 'inactive':
        return Badge(
          label: const Text('Inactive'),
          backgroundColor: Colors.red[400],
        );
      case 'banned':
        return Badge(
          label: const Text('Banned'),
          backgroundColor: Colors.grey[400],
        );
      default:
        return Text(type);
    }
  }
}

class User {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final String gender;
  final int noOfPosts;
  final int noOfFriends;
  final String role;
  final String status;
  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.fullName,
      required this.gender,
      required this.noOfPosts,
      required this.noOfFriends,
      required this.role,
      required this.status});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['fullName'] ?? '',
      gender: json['gender'] ?? '',
      noOfPosts: json['noOfPosts'],
      noOfFriends: json['noOfFriends'],
      role: json['role'],
      status: json['status'],
    );
  }
}
