import 'dart:convert';

import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Models/admin/admin_post.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Utils/admin_utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PostInfo extends StatefulWidget {
  final int id;
  const PostInfo({super.key, required this.id});

  @override
  State<PostInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<PostInfo> {
  late Future<Post> _post;

  @override
  void initState() {
    _post = _fetchPost();
    super.initState();
  }

  Future<Post> _fetchPost() async {
    var token = await DatabaseProvider().getToken();
    var url = '${AppUrl.adminPath}/posts/${widget.id}';
    Post result = Post(
        id: widget.id,
        content: '',
        creatorId: 0,
        creatorImage: '',
        creatorUsername: '',
        image: '',
        isBlocked: false,
        timestamp: '',
        reportTitleList: []);
    try {
      http.Response response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      });
      var parsed = jsonDecode(response.body);
      result = Post.fromJson(parsed);
    } catch (e) {
      print(e);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _post,
        builder: (context, snapshot) => snapshot.hasData
            ? Scaffold(
                appBar: AppBar(
                  title: const Text('Post'),
                ),
                body: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundImage: NetworkImage(
                                  getAvatar(snapshot.data!.creatorImage),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(snapshot.data!.creatorUsername, style: const TextStyle(fontWeight: FontWeight.bold),),
                                  Text(DateFormat("dd/MM/yyyy hh:mm aaa").format(DateTime.parse(snapshot.data!.timestamp)))
                                ],
                              ),
                            ],
                          ),
                          getStatus(snapshot.data!.isBlocked ? "blocked" : "active"),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Text(snapshot.data!.content),
                      const SizedBox(height: 10,),
                      if (snapshot.data!.image.isNotEmpty) Image.network(snapshot.data!.image)
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
