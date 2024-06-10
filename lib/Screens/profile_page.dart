import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).fetchProfile();
    });
  }
  @override
  Widget build(BuildContext context) {
    Profile? profile = Provider.of<UserProvider>(context).profile;
    bool isLoading = Provider.of<UserProvider>(context).isLoading;
    if(isLoading || profile==null){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: Container(
                color:TColors.darkerGrey,
                ),
            ),
            // Stack(
              // alignment: AlignmentDirectional.topStart,
              // clipBehavior: Clip.none,
              // children: <Widget> [
              //   Positioned(
              //     top: 0, 
              //     left: 20,
              //     child: SizedBox(
              //       width: 80,
              //       height: 80,
              //       child: CircleAvatar(
              //         child: Image.asset("assets/avatar/fuxuan.png",height: 80, width: 80,fit: BoxFit.fill,),
              //       ),
              //     ),
              //   ),
                // Column(
                //   children: [
                //     Expanded(
                //       child: Column(
                    
                //         children: [
                //           Row(
                //             children: [
                //               Text(profile.fullname, style:  Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),)
                //             ],
                //           ),
                          
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                
          //       ],
          //   )
          ],
        ),
      ),
    );
  }
}