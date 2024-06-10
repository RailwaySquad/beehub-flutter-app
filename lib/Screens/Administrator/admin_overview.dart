import 'dart:convert';

import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Overview extends StatelessWidget {
  const Overview({super.key});

  Future<List> _loadUsers() async {
    var token = await DatabaseProvider().getToken();
    var url = '${AppUrl.adminPath}/dashboard';
    List result = [];
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      var data = jsonDecode(response.body);
      result = [
        OverviewCard(
            number: data!['numOfUsers'],
            title: 'Users',
            icon: Icons.people_outline,
            color: Colors.yellow),
        OverviewCard(
            number: data!['numOfGroups'],
            title: 'Groups',
            icon: Icons.groups_sharp,
            color: Colors.green),
        OverviewCard(
            number: data!['numOfPosts'],
            title: 'Posts',
            icon: Icons.backup_table_outlined,
            color: Colors.blue),
        OverviewCard(
            number: data!['numOfReports'],
            title: 'Reports',
            icon: Icons.report_problem_outlined,
            color: Colors.red),
      ];
    } catch (e) {
      print(e);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadUsers(),
        builder: (context, snapshot) => snapshot.hasData
            ? GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: 4,
                itemBuilder: (context, index) => snapshot.data![index],
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10))
            : const Center(child: CircularProgressIndicator.adaptive()));
  }
}

class OverviewCard extends StatelessWidget {
  final int number;
  final String title;
  final IconData icon;
  final Color color;

  const OverviewCard(
      {super.key,
      required this.number,
      required this.title,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: color.withOpacity(0.7),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(1, 2))
          ]),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                number.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Theme.of(context).primaryColor),
              ),
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          Expanded(
            child: Center(
              child: Icon(
                icon,
                size: 80,
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          )
        ],
      ),
    );
  }
}
