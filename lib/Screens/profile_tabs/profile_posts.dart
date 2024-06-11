import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    Profile? profile = Provider.of<UserProvider>(context).profile;
    if(profile ==null || profile.posts!.isEmpty){
      return const Text("There are no post in user profile");
    }

    return SliverList.builder(
      itemCount: profile.posts!.length,
      itemBuilder: (context,index){ 
                    if(profile.posts!.isNotEmpty){
                      return PostWidget(post: profile.posts![index]);                  
                    }else{
                      return const Padding(
                        padding:  EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: Text("There are no post in user profile"),), 
                      );
                    }
                }
      // child: Card(
      //   child: ListView.builder(
      //             controller: controller,
      //             padding: const EdgeInsets.all(8),
      //             shrinkWrap: true,
      //             itemCount: profile.posts!.length,
      //             physics: const AlwaysScrollableScrollPhysics(),
      //             itemBuilder: (context,index){ 
      //               if(profile.posts!.isNotEmpty){
      //                 return PostWidget(post: profile.posts![index]);                  
      //               }else{
      //                 return const Padding(
      //                   padding:  EdgeInsets.symmetric(vertical: 32),
      //                   child: Center(child: Text("There are no post in user profile"),), 
      //                 );
      //               }
      //           }
      //   ),
      // ),
    );
  }
}