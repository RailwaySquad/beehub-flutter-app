import 'dart:convert';

import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Screens/Administrator/admin_groups.dart';
import 'package:beehub_flutter_app/Screens/Administrator/admin_overview.dart';
import 'package:beehub_flutter_app/Screens/Administrator/admin_posts.dart';
import 'package:beehub_flutter_app/Screens/Administrator/admin_reports.dart';
import 'package:beehub_flutter_app/Screens/Administrator/admin_shop.dart';
import 'package:beehub_flutter_app/Screens/Administrator/admin_users.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  Admin admin = Admin(createdAt: '', email: '', fullName: '', username: '');

  @override
  void initState() {
    _fetchAdminProfile();
    super.initState();
  }

  Future<void> _fetchAdminProfile() async {
    var token = await DatabaseProvider().getToken();
    var url = '${AppUrl.adminPath}/profile';
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      admin = Admin.fromJson(jsonDecode(response.body));
    } catch (e) {
      print(e);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    }
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Overview(),
    Reports(),
    AdminUsers(),
    AdminGroups(),
    AdminPosts(),
    Shop()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const DrawerButtonIcon(),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => _dialogBuilder(context))
        ],
      ),
      body: _widgetOptions[_selectedIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: const Center(
                  child: Text(
                'B E E H U B',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
            ),
            ListTile(
              title: const Text('Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Reports'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Users'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Groups'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Posts'),
              selected: _selectedIndex == 4,
              onTap: () {
                _onItemTapped(4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Shop'),
              selected: _selectedIndex == 5,
              onTap: () {
                _onItemTapped(5);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Profile'),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                admin.fullName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(admin.email),
              Text(
                  'Member since ${DateFormat.yMd().format(DateTime.parse(admin.createdAt))}'),
            ],
          ),
          actions: [
            OutlinedButton(
                onPressed: () {
                  DatabaseProvider().logOut(context);
                },
                child: const Text('Log out'))
          ],
        ),
      );
}

class Admin {
  Admin(
      {required this.username,
      required this.fullName,
      required this.email,
      required this.createdAt});

  String username;
  String fullName;
  String email;
  String createdAt;

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
        username: json['username'],
        email: json['email'],
        fullName: json['fullName'],
        createdAt: json['createdAt']);
  }
}
