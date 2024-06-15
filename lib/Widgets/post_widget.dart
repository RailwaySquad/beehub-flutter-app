import 'dart:developer';

import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/like.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_post.dart';
import 'package:beehub_flutter_app/Utils/helper/helper_functions.dart';
import 'package:beehub_flutter_app/Utils/shadow/shadows.dart';
import 'package:beehub_flutter_app/Widgets/editpost_widget.dart';
import 'package:beehub_flutter_app/Widgets/expanded/expanded_widget.dart';
import 'package:beehub_flutter_app/Widgets/showcommentpost.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostWidget extends StatefulWidget {
  final void Function() onUpdatePostList;
  const PostWidget({super.key,required this.post,required this.onUpdatePostList});
  final Post post;
  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  bool _isOptionsVisible = false;
  int _countComment = 0;
  int _countLike = 0;
  late int _checkUser ;
  bool _checkLike = false;
  void _toggleOptionsVisibility() {
    setState(() {
      _isOptionsVisible = !_isOptionsVisible;
    });
  }
  void _initializeUser() async {
    DatabaseProvider db = DatabaseProvider();
    _checkUser = await db.getUserId();
  }
  @override
  void initState(){
    super.initState();
    _fetchCountComment();
    _fetchCheckLike();
    _fetchCountLike();
    _initializeUser();
  }
  String formatDate(DateTime? date){
    if(date == null) return '';
    final now = DateTime.now();
    final difference = now.difference(date);
    if(difference.inDays > 365){
      final years = (difference.inDays / 365).floor();
      return '$years year ago'; 
    }else if(difference.inDays >= 30){
      final months = (difference.inDays / 30).floor();
      return '$months month ago';
    }else if(difference.inDays >= 1){
      return '${difference.inDays} day ago';
    }else if(difference.inHours >= 1){
      return '${difference.inHours} hours ago';
    }else if(difference.inMinutes >= 1){
      return '${difference.inMinutes} minutes ago';
    }else{
      return 'Now' ;
    }
  }
  Widget getMedia(height, width) {
    if (widget.post.medias != null) {
      return SizedBox(
        height: height,
        width: width,
        child: Image.network(widget.post.medias!),
      );
    }
    return const SizedBox(height: 0);
  }
  void _fetchCountComment() async{
    int count = await ApiService.countComment(widget.post.id);
    setState(() {
      _countComment = count;
    });
  }
  void _fetchCountLike() async{
    int count = await ApiService.countLike(widget.post.id);
    setState(() {
      _countLike = count;
    });
  }
  void _fetchCheckLike() async{
    DatabaseProvider db = DatabaseProvider();
    int userid = await db.getUserId();
    int postid = widget.post.id;
    bool checkLikePost = await ApiService.checkLike(userid,postid);
    setState(() {
      _checkLike = checkLikePost;
    });
  }
  @override
  Widget build(BuildContext context) {
    Color parseColor(String? colorString) {
      if (colorString == null || colorString.isEmpty) {
        return Colors.transparent;
      } else {
        if (colorString.startsWith('#')) {
          colorString = 'ff${colorString.substring(1)}';
        }
        return Color(int.parse(colorString, radix: 16) + 0xFF000000);
      }
    }
    final dark = THelperFunction.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        color: dark ? TColors.darkerGrey : Colors.white,
        boxShadow: [
          dark ? TShadowStyle.postShadowDark : TShadowStyle.postShadowLight
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      child: Row(
                        children: <Widget>[
                          //Avatar
                          CircleAvatar(
                            child: widget.post.userImage != null &&
                                    widget.post.userImage!.isNotEmpty
                                ? Image.network(widget.post.userImage!)
                                : Image.asset(widget.post.userGender == "female"
                                    ? "assets/avatar/user_female.png"
                                    : "assets/avatar/user_male.png"),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          //Fullname
                          SizedBox(
                              child: widget.post.groupName != null &&
                                      widget.post.groupName!.isNotEmpty
                                  ? Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                          Text(
                                            widget.post.userFullname,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            textAlign: TextAlign.left,
                                          ),
                                          Text.rich(TextSpan(
                                              text: " in ",
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text: widget.post.groupName!,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.bold),recognizer: TapGestureRecognizer()..onTap = () => Get.toNamed("/group/${widget.post.groupId!}")
                                                )
                                              ]))
                                        ]),
                                        Text(formatDate(widget.post.createdAt))
                                    ],
                                  )
                                  : InkWell(
                                     onTap: (){
                                      Provider.of<UserProvider>(context, listen: false).setUsername(widget.post.userUsername);
                                      log(Provider.of<UserProvider>(context, listen: false).username!);
                                      Get.toNamed("/userpage/${widget.post.userUsername}");
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.post.userFullname,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          textAlign: TextAlign.left,
                                        ),
                                        Text(formatDate(widget.post.createdAt))
                                      ],
                                    ),
                                  ))
                        ],
                      ),
                    ),
                    //Icon setting
                    IconButton(
                      onPressed: _toggleOptionsVisibility,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                //Post Content
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      widget.post.background != "ffffffff" &&
                              widget.post.background != "inherit"
                          ? Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Container(
                                      height: 200,
                                      color: parseColor(widget.post.background),
                                      child: Center(
                                        child: Text(
                                          widget.post.text,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color:
                                                  parseColor(widget.post.color),
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: ExpandedWidget(
                                            text: widget.post.text)))
                              ],
                            )
                    ],
                  ),
                ),
                if (widget.post.medias != null &&
                    widget.post.medias!.isNotEmpty)
                  Image.network(
                    widget.post.medias!,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //Like
                    SizedBox(
                      child: Column(
                        children: [
                          Text(
                            "$_countLike",
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                          ),
                          Row(
                            children: [
                              _checkLike == true ?
                              IconButton(
                                  onPressed: () async{
                                    try{
                                      DatabaseProvider db = new DatabaseProvider();
                                      int userid = await db.getUserId();
                                      int postid = widget.post.id;
                                      await ApiService.removeLike(userid, postid);
                                    }catch(e){
                                      print('Error to remove Like: $e');
                                    }
                                    _fetchCheckLike();
                                    _fetchCountLike();
                                  },
                                  icon: const Text('👍'))
                                  :IconButton(
                                  onPressed: () async{
                                    try{
                                      DatabaseProvider db = DatabaseProvider();
                                      int userid = await db.getUserId();
                                      int postid = widget.post.id;
                                      Like like = Like(
                                        enumEmo: '👍',
                                        user: userid,
                                        post: postid
                                      );
                                      await ApiService.addLike(like);
                                    }catch(e){
                                      print('Error to add Like: $e');
                                    }
                                    _fetchCheckLike();
                                    _fetchCountLike();
                                  },
                                  icon: const Icon(
                                    Icons.thumb_up_alt_outlined)) ,
                              const Text("Like")
                            ],
                          ),
                        ],
                      ),
                    ),
                    //Comment
                    SizedBox(
                      child: Column(
                        children: [
                          Text(
                            "$_countComment",
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              ApiService.getPostById(widget.post.id).then((post) {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ShowComment(post: post,fetchCountComment:_fetchCountComment,fetchCheckLike:_fetchCheckLike,fetchCountLike:_fetchCountLike,countLike:_countLike,checkLike:_checkLike); // Gọi StatefulWidget mới
                                  },
                                );
                              });
                            },
                            
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent, // Bỏ màu nền mặc định
                              elevation: 0, // Bỏ shadow
                              shadowColor: Colors.transparent, // Bỏ shadow màu
                              side: BorderSide.none, // Bỏ border
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                        Icons.messenger_outline_rounded),color: Colors.black,),
                                const Text("Comment",style: TextStyle(color: Colors.black),)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    //Share
                    SizedBox(
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.share)),
                          const Text("Share")
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            if (_isOptionsVisible)
              Positioned(
                top: 40,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10), // Tạo viền tròn
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Màu của shadow
                        spreadRadius: 1, // Độ lan của shadow
                        blurRadius: 5, // Độ mờ của shadow
                        offset: Offset(0, 3), // Vị trí của shadow
                      ),
                    ],
                  ),
                  width: 200,           
                  child:
                  _checkUser == widget.post.userId ? 
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          ApiService.getPostById(widget.post.id).then((post) {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return EditPostPage(post: post,onUpdatePostList: widget.onUpdatePostList); // Gọi StatefulWidget mới
                              },
                            );
                          });
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent, // Bỏ màu nền mặc định
                          elevation: 0, // Bỏ shadow
                          shadowColor: Colors.transparent, // Bỏ shadow màu
                          side: BorderSide.none, // Bỏ border
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 10),
                            Text('Edit')
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async{
                          bool confirmDelete = await showDialog(
                            context: context, 
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text('Are you sure you want to delete post ?'),
                                actions: [
                                  TextButton(
                                    onPressed: (){
                                      Navigator.of(context).pop(false);
                                    }, 
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: (){
                                      Navigator.of(context).pop(true);
                                    }, 
                                    child: const Text('Ok')
                                  )
                                ],
                              );
                            }
                          );
                          if(confirmDelete == true){
                            int postId = widget.post.id;
                            ApiService.deletePost(postId).then((_){
                              widget.onUpdatePostList();
                            });
                          }
                        },
                        
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent, // Bỏ màu nền mặc định
                          elevation: 0, // Bỏ shadow
                          shadowColor: Colors.transparent, // Bỏ shadow màu
                          side: BorderSide.none, // Bỏ border
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 10),
                            Text('Delete')
                          ],
                        ),
                      ),
                    ],
                  ):Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent, // Bỏ màu nền mặc định
                          elevation: 0, // Bỏ shadow
                          shadowColor: Colors.transparent, // Bỏ shadow màu
                          side: BorderSide.none, // Bỏ border
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.report),
                            SizedBox(width: 10),
                            Text('Report')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
