import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:beehub_flutter_app/Widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupDiscussion extends StatefulWidget {
  const GroupDiscussion({super.key});

  @override
  State<GroupDiscussion> createState() => _GroupDiscussionState();
}

class _GroupDiscussionState extends State<GroupDiscussion> {
  final controller = ScrollController();
  List<Group> groups = [];
  List<Post> posts = [];
  num? idGroup;
  bool isLoading = false;
  bool hasMore = true;
  int page = 0;
  bool errorConnect = false;
  Future fetchGroup() async {
    if (isLoading) return;
    isLoading = true;
    List<Group>? listGr = await THttpHelper.getGroups();
    setState(() {
      isLoading = false;
      if (listGr == null) {
        errorConnect = true;
      } else {
        groups.addAll(listGr);
        fetchPost(page);
      }
    });
  }

  Future fetchPost(int pageX) async {
    if (isLoading) return;
    isLoading = true;
    List<Post>? fetchPost = await THttpHelper.getGroupPosts(idGroup!, pageX);
    setState(() {
      isLoading = false;
      if (fetchPost == null) {
        errorConnect = true;
      } else {
        if (fetchPost.length < 5) {
          hasMore = false;
        }
        posts.addAll(fetchPost);
      }
    });
  }

  Future refresh() async {
    setState(() {
      isLoading = false;
      hasMore = true;
      page = 0;
      posts.clear();
    });
    if (idGroup != null) {
      fetchPost(page);
    }
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    idGroup = Get.parameters["idGroup"] != null
        ? num.parse(Get.parameters["idGroup"]!)
        : null;
    if (idGroup != null) {
      fetchPost(page);
    }
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        setState(() {
          page++;
        });
        fetchPost(page);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void updatePostList() {
    setState(() {
      page = 0;
      posts.clear();
      hasMore = true;
      fetchGroup();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) {
      return  SliverToBoxAdapter(
          child: Center(  heightFactor: 4.0,child: Text("Not Found Post",style: Theme.of(context).textTheme.headlineMedium),));
    }
    return SliverList.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          if (posts.isNotEmpty) {
            return PostWidget(
                onUpdatePostList: updatePostList, post: posts[index]);
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(TColors.buttonPrimary),
              ),
            );
          }
        });
  }
}
