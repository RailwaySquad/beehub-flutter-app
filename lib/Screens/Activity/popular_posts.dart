import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
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
  Future refresh () async{
    setState(() {
      isLoading = false;
      hasMore = true;
      page=0;
      list.clear();
    });
    fetchPost ();
  }
  @override
  void initState() {
    super.initState();
    fetchPost ();
    controller.addListener((){
      if(controller.position.maxScrollExtent == controller.offset){
        fetchPost ();
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
              itemCount: list.length+1,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context,index){ 
                if(index<list.length){
                  return PostWidget(post: list[index]);                  
                }else{
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: hasMore?const CircularProgressIndicator(): const Text("No more post")), 
                  );
                }
            }
      ),
    );
   
  }
}
