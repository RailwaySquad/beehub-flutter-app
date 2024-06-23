import 'dart:convert';

import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Models/admin/admin_user.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Utils/admin_utils.dart';
import 'package:beehub_flutter_app/Widgets/admin/role_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UserInfo extends StatefulWidget {
  final int id;
  const UserInfo({super.key, required this.id});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late Future<User> _user;

  @override
  void initState() {
    _user = _fetchUser();
    super.initState();
  }

  Future<User> _fetchUser() async {
    var token = await DatabaseProvider().getToken();
    var url = '${AppUrl.adminPath}/users/${widget.id}';
    User result = User(
        id: widget.id,
        email: '',
        username: '',
        fullName: '',
        gender: '',
        noOfFriends: 0,
        noOfPosts: 0,
        role: '',
        status: '',
        avatar: '',
        createdAt: '',
        reportTitleList: [],
        gallery: []);
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      var parsed = jsonDecode(response.body);
      result = User.fromJson(parsed);
    } catch (e) {
      print(e);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _user,
        builder: (context, snapshot) => snapshot.hasData
            ? Scaffold(
                appBar: AppBar(
                  title: const Text('User'),
                ),
                body: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 72,
                            backgroundImage: NetworkImage(
                              getAvatar(snapshot.data!.avatar),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              infoList('Username: ',
                                  [Text(snapshot.data!.username)]),
                              infoList('Full Name: ',
                                  [Text(snapshot.data!.fullName)]),
                              infoList('Email: ', [Text(snapshot.data!.email)]),
                              infoList('Gender: ', [
                                getGender(snapshot.data!.gender),
                                Text(snapshot.data!.gender)
                              ]),
                              infoList('Friends: ', [
                                Text(snapshot.data!.noOfFriends.toString())
                              ]),
                              infoList('Posts: ',
                                  [Text(snapshot.data!.noOfPosts.toString())]),
                              infoList('Status: ',
                                  [getStatus(snapshot.data!.status)]),
                              infoList('Role: ', [
                                RoleDropdown(
                                  userId: snapshot.data!.id,
                                  role: snapshot.data!.role,
                                )
                              ]),
                              infoList(
                                  'Report: ',
                                  getMultipleReportType(
                                      snapshot.data!.reportTitleList)),
                              infoList('Member since: ', [
                                Text(DateFormat("dd/MM/yyyy").format(
                                    DateTime.parse(snapshot.data!.createdAt)))
                              ]),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Gallery',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 3 / 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          children: snapshot.data!.gallery
                              .map((e) => Image.network(
                                    e,
                                    fit: BoxFit.cover,
                                  ))
                              .toList(),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : const Scaffold(
                body: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ));
  }
}
