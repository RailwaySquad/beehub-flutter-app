
import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_post.dart';
import 'package:beehub_flutter_app/Utils/helper/helper_functions.dart';
import 'package:beehub_flutter_app/Utils/shadow/shadows.dart';
import 'package:beehub_flutter_app/Widgets/expanded/expanded_widget.dart';
import 'package:beehub_flutter_app/Widgets/showcommentpost.dart';
import 'package:flutter/material.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({super.key, required this.post,});
  final Post post;
  Widget getMedia (height,width){
    if(post.medias!=null){
      return SizedBox(
        height: height,
        width: width,
        child: Image.network(post.medias!),
      );
    }
    return const SizedBox(height: 0);
  }
  @override
  Widget build(BuildContext context) {
    Color parseColor(String? colorString) {
      if (colorString == null || colorString.isEmpty) {
        // Trả về màu mặc định nếu chuỗi màu trống
        return Colors.transparent;
      } else {
        // Chuyển đổi chuỗi màu sang đối tượng Color
        return Color(int.parse(colorString, radix: 16) + 0xFF000000);
      }
    }
    final dark = THelperFunction.isDarkMode(context);
    return Container(
      decoration:BoxDecoration(
        color: dark?TColors.darkerGrey:Colors.white,
        boxShadow: [dark? TShadowStyle.postShadowDark: TShadowStyle.postShadowLight]
        ),
      
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
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
                          child: post.userImage!=null && post.userImage!.isNotEmpty
                                ? Image.network(post.userImage!)
                                : Image.asset(post.userGender=="female"? "assets/avatar/user_female.png": "assets/avatar/user_male.png"),
                        ),
                        const SizedBox(width: 10,),
                      //Fullname
                        SizedBox(
                          child: post.groupName!=null&& post.groupName!.isNotEmpty
                              ? Row(
                               children: [
                                Text(post.userFullname,style:  Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 1,textAlign: TextAlign.left,),
                               Text.rich( TextSpan(
                                  text: " in ",
                                  children: <InlineSpan>[
                                    TextSpan(text: post.groupName!, style: const TextStyle(fontWeight: FontWeight.bold),)
                                  ] )
                               )])
                               : Row(children: [
                                Text(post.userFullname,style:  Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,maxLines: 1,textAlign: TextAlign.left,)
                               ],)
                              )
                      ],
                    ),
                  ),
                  //Icon setting
                  IconButton(onPressed: (){}, icon: const Icon(Icons.keyboard_arrow_down_rounded))
                ],
              ),
              const SizedBox(height: 10,),
              //Post Content
              SizedBox(
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max, 
                  children: [
                    post.background != "ffffffff" && post.background != "inherit"?
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(width: 10,),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container( 
                              height: 200, 
                              color: parseColor(post.background), 
                              child: Center( 
                                child: Text(
                                  post.text,
                                  textAlign: TextAlign.center, 
                                  style: TextStyle( 
                                    color: parseColor(post.color),
                                    fontSize: 20  
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ):Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(width: 10,),
                        Expanded(
                          child: SingleChildScrollView(
                            child: ExpandedWidget(text: post.text)))
                      ],
                    )
                  ],),
              ),
              if (post.medias != null && post.medias!.isNotEmpty)
              Container(
                child: Image.network(
                  post.medias!,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                //Like
                SizedBox(
                  child: Column(
                    children: [
                      Text("0", style:  Theme.of(context).textTheme.bodySmall,maxLines: 1,),
                      Row(
                        children: [
                          IconButton(onPressed: (){}, icon: const Icon(Icons.thumb_up_alt_outlined)),
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
                      Text("0", style:  Theme.of(context).textTheme.bodySmall,maxLines: 1,),
                      ElevatedButton(
                        onPressed: () {
                          ApiService.getPostById(post.id!).then((post){
                            showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return ShowComment(post: post); // Gọi StatefulWidget mới
                            },
                          );
                          });    
                        },
                        child: Row(
                          children: [
                            IconButton(onPressed: (){}, icon: const Icon(Icons.messenger_outline_rounded)),
                            const Text("Comment")
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
                      IconButton(onPressed: (){}, icon: const Icon(Icons.share)),
                      const Text("Share")
                    ],
                  ),
                )
                ],
              )
            ],
          ),
      ),
    );
  }
}
