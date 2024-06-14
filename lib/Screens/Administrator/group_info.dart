import 'dart:convert';

import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GroupInfo extends StatefulWidget {
  final int id;
  const GroupInfo({super.key, required this.id});

  @override
  State<GroupInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<GroupInfo> {
  late Future<Group> _group;

  @override
  void initState() {
    _group = _fetchGroup();
    super.initState();
  }

  Future<Group> _fetchGroup() async {
    var token = await DatabaseProvider().getToken();
    var url = '${AppUrl.adminPath}/groups/${widget.id}';
    Group result = Group(
        id: widget.id,
        groupImage: '',
        groupName: '',
        noOfMembers: 0,
        noOfPosts: 0,
        isActive: false,
        isPublic: false,
        gallery: []);
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      var parsed = jsonDecode(response.body);
      result = Group.fromJson(parsed);
    } catch (e) {
      print(e);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _group,
        builder: (context, snapshot) => snapshot.hasData
            ? Scaffold(
                appBar: AppBar(
                  title: const Text('Group'),
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
                              snapshot.data!.groupImage,
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoList('Group Name: ', snapshot.data!.groupName),
                              _infoList('Visibility: ', snapshot.data!.isPublic ? 'Public' : 'Private'),
                              _infoList('Members: ', snapshot.data!.noOfMembers.toString()),
                              _infoList('Posts: ', snapshot.data!.noOfPosts.toString()),
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

  _infoList(String title, String content) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black)),
      TextSpan(text: content, style: const TextStyle(color: Colors.black))
    ]));
  }
}

class Group {
  final int id;
  final String groupName;
  final String groupImage;
  final int noOfMembers;
  final int noOfPosts;
  final bool isActive;
  final bool isPublic;
  final List<dynamic> gallery;

  Group({
    required this.id,
    required this.groupName,
    required this.groupImage,
    required this.noOfMembers,
    required this.noOfPosts,
    required this.isActive,
    required this.isPublic,
    required this.gallery,
  });
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      groupName: json['groupname'],
      groupImage: json['image_group'],
      noOfMembers: json['member_count'],
      noOfPosts: json['post_count'],
      isActive: json['active'],
      isPublic: json['public_group'],
      gallery: (json['group_medias'] as List).map((e) => e['media'] as String).toList(),
    );
  }
}
