import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Screens/Profile/profile_about.dart';
import 'package:beehub_flutter_app/Screens/Profile/profile_gallery.dart';
import 'package:beehub_flutter_app/Screens/Profile/profile_posts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> tabs = [
    "Posts",
    "About",
    "Gallery"
  ];
  int currentTab =0;
  double changePositionedOfLine(){
    switch (currentTab) {
      case 0:
        return 0;
      case 1:
        return 58;
      case 2:
        return 122;
      default:
        return 0;
    }
  }
  double changeContainerWidth(){
    switch (currentTab) {
      case 0:
        return 45;
      case 1:
        return 45;
      case 2:
        return 55 ;
      default:
        return 0;
    }
  }
  Widget changeSection(tab){
      switch (tab) {
        case "Posts":
          return const ProfilePosts();
        case "About":
          return const ProfileAbout();
        case "Gallery":
          return const ProfileGallery();
        
        default:
          return const Placeholder();
      }
  }
  
  @override
  Widget build(BuildContext context) {
    Profile? profile = Provider.of<UserProvider>(context, listen: false).ownprofile;
    
    var size = MediaQuery.of(context).size;
    bool isLoading = Provider.of<UserProvider>(context).isLoading;
    if(isLoading || profile==null){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    Provider.of<UserProvider>(context, listen: false).profile = profile;
    return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                    decoration: const BoxDecoration(
                      border:  Border(bottom: BorderSide(color: TColors.secondary,width: 2.0))
                    ),
                  height: 220,
                  width: size.width,
                  child: Container(
                    color:TColors.darkerGrey,
                    child: profile.background!.isNotEmpty? Image.network(profile.background!,fit: BoxFit.cover,): const SizedBox(),
                    ),
                ),
                Positioned(
                  top: 160, 
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black,width: 1.0),
                      borderRadius: BorderRadius.circular(45.0),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: profile.image!.isNotEmpty? NetworkImage(profile.image!)
                        :(profile.gender == 'female'?
                      const AssetImage("assets/avatar/user_female.png") as ImageProvider: const AssetImage("assets/avatar/user_male.png") as ImageProvider
                      ))
                    ),
                    width: 90,
                    height: 90,
                    child: const SizedBox()
                  ),
                ),
                Container(
                  width: size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 220,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                height: 70,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(profile.fullname, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                                    Text("@${profile.username}", style: Theme.of(context).textTheme.labelMedium,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          IconButton.outlined( 
                              onPressed: (){
                                Get.toNamed("/account_setting");
                              },
                              icon: const Icon(Icons.settings),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(profile.bio!)
                            ),
                            profile.createdAt!=null? Text("Created at ${DateFormat.yMMMMd('en_US').format(profile.createdAt!)}"): const Text(""),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.width/2,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: ()=>Get.toNamed("/userpage/friend_group/${profile.username}"),
                                child: RichText(text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(text: profile.relationships!.where((e)=> e.typeRelationship!="BLOCKED" ).length.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const TextSpan(text: " friends"),
                                    ]
                                )),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: TextButton(
                                onPressed: ()=>Get.toNamed("/userpage/friend_group/${profile.username}"),
                                child: RichText(text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(text: profile.groupJoined!.length.toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const TextSpan(text: " groups"),
                                    ]
                                )),
                              ),
                            )  
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height*0.05,
                        child: Stack(children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: SizedBox(
                              width: size.width,
                              height: size.height * 0.04,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                itemCount: tabs.length,
                                itemBuilder: (context,index){
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        currentTab = index;
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left:index==0?10:22,
                                        top: 7),
                                      child: Text(tabs[index],style: GoogleFonts.ubuntu(
                                        fontSize: currentTab==index? 16:14,
                                        fontWeight: currentTab==index?FontWeight.w400: FontWeight.w300),),
                                    ),
                                  );
                                }),
                            ),
                          ),
                          AnimatedPositioned(
                            bottom: 0,
                            left: changePositionedOfLine(),
                            curve: Curves.fastLinearToSlowEaseIn,
                            duration: const Duration(milliseconds: 500),
                            child: AnimatedContainer(
                              curve: Curves.fastLinearToSlowEaseIn,
                              margin: const EdgeInsets.only(left: 10),
                              duration:const Duration(milliseconds: 500),
                              width: changeContainerWidth(),
                              height: size.height*0.008,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: TColors.primary),
                              ),
                          )
                        ],)
                      ),    
                    ],
                  ),
                )
              ]
            ),
          ),
          changeSection(tabs[currentTab])
        ]
      );
  }
}

