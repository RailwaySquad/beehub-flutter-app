import 'package:beehub_flutter_app/Constants/color.dart';
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
  List<Post> list = [];
  num? idGroup;
  bool isLoading =false;
  bool hasMore = true;
  int page = 0;
  bool errorConnect = false;
  Future fetchPost(int pageX)async{
    if(isLoading) return;
    isLoading = true;
    List<Post>? fetchPost = await THttpHelper.getGroupPosts(idGroup!, pageX);
    setState(() {
      isLoading = false;
      if(fetchPost==null){
        errorConnect = true;
      }else{
        if (fetchPost.length<5) {
          hasMore = false;
        }
        list.addAll(fetchPost);
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
    if(idGroup!=null){
     fetchPost(page);
    }
  }
  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
  @override
  void initState() {
    super.initState();
    idGroup = Get.parameters["idGroup"]!=null? num.parse(Get.parameters["idGroup"]!): null;
    if(idGroup!=null){
      fetchPost(page);
    }
     controller.addListener((){
      if(controller.position.maxScrollExtent == controller.offset ){
        setState(() {
          page++;
        });
        fetchPost (page);
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
    if(list.isEmpty){
      return const SliverToBoxAdapter(child: SizedBox(child: Text("There are no post in user profile")));
    }
    return SliverList.builder(
      itemCount: list.length,
      itemBuilder: (context,index){
         if(list.isNotEmpty){
                      return PostWidget(post: list[index]);                  
                    }else{
                      return const Padding(
                        padding:  EdgeInsets.symmetric(vertical: 32),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(TColors.buttonPrimary),
                        ), 
                      );
                    }
      });
  }
}