import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_post.dart';
import 'package:beehub_flutter_app/Widgets/addpost_widget.dart';
import 'package:beehub_flutter_app/Widgets/post_widget.dart';

import 'package:flutter/material.dart';

class PopularPosts extends StatefulWidget {
  const PopularPosts({
    super.key,
  });

  @override
  State<PopularPosts> createState() => _PopularPostsState();
}

class _PopularPostsState extends State<PopularPosts> {
  final controller = ScrollController();
  List<Post> list = [];
  bool hasMore = true;
  int page = 0;
  bool isLoading=false;
  bool errorConnect = false;
 
  Future fetchPost ()async{
    if(isLoading) return;
    isLoading = true;
    List<Post>? addPosts =await THttpHelper.getPopularPosts(page);
    if(mounted){
      setState(() {
        page++;
        isLoading = false;
        if(addPosts!=null &&addPosts.length<5){
          hasMore=false;
        }
        if(addPosts==null){
          errorConnect = true;
        }else{
          list.addAll(addPosts);
        }
      });
    }
  }
  
  void updatePostList(){
    setState(() {
      page = 0;
      list.clear();
      hasMore = true;
      fetchPost();
    });
  }
  Future refresh() async {
    setState(() {
      isLoading = false;
      hasMore = true;
      page = 0;
      list.clear();
    });
    fetchPost();
  }

  @override
  void initState() {
    super.initState();
    fetchPost();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetchPost();
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
    if(errorConnect){
      return const Text("Error connect Server");
    }
    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        controller: controller,
        padding: const EdgeInsets.all(8),
        shrinkWrap: true,
        itemCount: list.length + 2, // +2 because we added a header and a footer
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index == 0) {
             return Container(
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.account_circle, size: 40.0),
                  SizedBox(
                    width: 300.0,
                    height: 40.0,
                    child: ElevatedButton(
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Bạn đang nghĩ gì ?',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      onPressed: () async {
                        DatabaseProvider db = DatabaseProvider();
                        int userid = await db.getUserId();
                        ApiService.getUserById(userid).then((user){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreatePostPage(onUpdatePostList: updatePostList,user:user),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (index <= list.length) {
            return PostWidget(post: list[index - 1],onUpdatePostList: updatePostList); // Adjust index for header
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: hasMore
                    ? const CircularProgressIndicator()
                    : const Text("No more post found"),
              ),
            );
          }
        },
      ),
    );
  }
}
