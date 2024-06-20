import 'dart:convert';

import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Models/admin/admin_user.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
                              snapshot.data!.avatar,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoList('Username: ', snapshot.data!.username),
                              _infoList('Full Name: ', snapshot.data!.fullName),
                              _infoList('Email: ', snapshot.data!.email),
                              _infoList('Gender: ', snapshot.data!.gender),
                              _infoList(
                                  'Role: ', _getRole(snapshot.data!.role)),
                              _infoList('Status: ', snapshot.data!.status),
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

  _getRole(String type) {
    switch (type) {
      case 'ROLE_ADMIN':
        return 'Admin';
      case 'ROLE_USER':
        return 'User';
      default:
        return '';
    }
  }

  _infoList(String title, String content) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      TextSpan(text: content, style: const TextStyle(color: Colors.black))
    ]));
  }
}
