import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:beehub_flutter_app/Widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GroupPosts extends StatefulWidget {
  const GroupPosts({
    super.key,
  });

  @override
  State<GroupPosts> createState() => _GroupPostsState();
}
class _GroupPostsState extends State<GroupPosts> {
  final controller = ScrollController();
  List<Group> groups = [];
  List<Post> listPosts = [];
  bool hasMore = true;
  int page = 0;
  bool isLoading=false;
  int selectGroup = 0;
  bool errorConnect = false;
  Future fetchGroup() async{
    if(isLoading) return;
    isLoading = true;
    List<Group>? listGr = await THttpHelper.getGroups();
    setState(() {
      isLoading = false;
      if(listGr==null){
        errorConnect = true;
      }else{
        groups.addAll(listGr);
        if(groups.isNotEmpty){
          fetchGroupPosts (listGr[0].id!, page);
        }
      }
    });
  }
  Future fetchGroupPosts (num idSelect, int pageX) async{
    if(isLoading) return;
    isLoading = true;
    List<Post>? fetchPost = await THttpHelper.getGroupPosts(idSelect, pageX);
    setState(() {
      isLoading = false;
      if(fetchPost == null){
        errorConnect = true;
      }else{
        if(fetchPost.length<5){
          hasMore = false;
        }
        listPosts.addAll(fetchPost);
      }
    });
  }
  Future refresh () async{
    setState(() {
      isLoading = false;
      hasMore = true;
      page=0;
      listPosts.clear();
    });
    fetchGroupPosts(groups[selectGroup].id!,page);
  }
  void updatePostList(){
    setState(() {
      page = 0;
      listPosts.clear();
      hasMore = true;
      fetchGroup();
    });
  }
@override
  void initState() {
    super.initState();
    fetchGroup ();
    
    controller.addListener((){
      if(controller.position.maxScrollExtent == controller.offset ){
        if(groups.isNotEmpty){
          setState(() {
            page++;
          });
          fetchGroupPosts (groups[selectGroup].id!, page);
        }
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
    bool isLoading = Provider.of<UserProvider>(context).isLoading;
    var size = MediaQuery.of(context).size;
    if(errorConnect){
      return const Text("Error connect Server");
    }
    if(isLoading){
      return const Center(
        heightFactor: 100,
        child: CircularProgressIndicator(color: TColors.buttonPrimary,),
      );
    }
    return Column(
          children: [
            SizedBox(
              width: size.width,
              height: 80,
              //List Group
              child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: groups.length,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      itemBuilder: (context,index){
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectGroup = index;
                              page=0;
                              listPosts.clear();
                            });
                            fetchGroupPosts(groups[selectGroup].id!,page);
                          },
                          onDoubleTap: (){
                            Get.toNamed("/group/${groups[index].id!}");
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left:index==0?10:16),
                                  child: Column(
                                        children: [  
                                          Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration:  BoxDecoration(
                                                border: Border.all(color: selectGroup==index?TColors.borderPrimary :TColors.darkGrey, width: selectGroup==index? 2 :1),
                                                borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                                              ),
                                              child: CircleAvatar(
                                                backgroundColor: TColors.white,
                                                child: groups[index].imageGroup!=null
                                                      ? Image.network(groups[index].imageGroup!)
                                                      : Image.asset("assets/avatar/group_image.png"),
                                                ),
                                            ),
                                              Text(groups[index].groupname, textAlign:TextAlign.center, style: TextStyle(fontWeight: selectGroup==index? FontWeight.bold: FontWeight.normal),),
                                        ],
                                      ),
                                ),
                              ],
                          ),
                        );
                      }, 
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10,),),
            ),
            
            Expanded(
              child: RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  itemCount: listPosts.length+1,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index){
                    if(listPosts.isEmpty){
                      return const Center(
                        child: Text("Not found the group joined"),
                      );
                    }
                    if(index<listPosts.length){
                    return PostWidget(post: listPosts[index],onUpdatePostList: updatePostList);                  
                    }else{
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: hasMore?const CircularProgressIndicator(): const Row(
                          children: [
                            Expanded(
                                        child: Divider()
                                    ),
                          ],
                        ), ), 
                      );
                    }
                  })),
            )
            
          ],
        );
  }
}

