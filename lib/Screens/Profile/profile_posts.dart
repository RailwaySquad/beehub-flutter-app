import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:beehub_flutter_app/Widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePosts extends StatefulWidget {
  const ProfilePosts({super.key});
  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  final controller = ScrollController();
  List<Post> posts = [];
  bool hasMore = true;
  int page = 0;
  bool isLoading = false;
  bool errorConnect = false;
  String username = "";
  Future fetchProfilePost() async {
    if (isLoading) return;
    isLoading = true;
    List<Post>? post = await THttpHelper.getProfilePost(username, page);
    setState(() {
      page++;
      isLoading = false;
      if (post != null && post.length < 5) {
        hasMore = false;
      }
      if (post == null) {
        errorConnect = true;
      } else {
        posts.addAll(post);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetchProfilePost();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String? usern =
          Provider.of<UserProvider>(context, listen: false).username;
      if (usern != null) {
        username = usern;
        fetchProfilePost();
      } else {
        Provider.of<UserProvider>(context, listen: false).getUsername();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void updatePostList() {
      setState(() {
        page = 0;
        posts.clear();
        hasMore = true;
        fetchProfilePost();
      });
    }

    if (posts.isEmpty) {
      return const SliverToBoxAdapter(
          child: SizedBox(child: Text("There are no post in user profile")));
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
