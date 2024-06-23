import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Screens/Activity/activity_screen.dart';
import 'package:beehub_flutter_app/Screens/Following/following_screen.dart';
import 'package:beehub_flutter_app/Screens/notifications_screen.dart';
import 'package:beehub_flutter_app/Screens/Profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Get.put(NavigationController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).fetchProfile(true);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const BeehubDrawer(),
      body: Obx(()=>controller.screens[controller.selectedIndex.value]),
      
      bottomNavigationBar: Obx(
        ()=> NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index){
            controller.selectedIndex.value = index;
          },
          // labelBehavior:  NavigationDestinationLabelBehavior.alwaysHide,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: "Home"),
            NavigationDestination(icon: Icon(Icons.favorite), label: "Following"),
            NavigationDestination(icon: Icon(Icons.notifications), label: "Notifications"),
            NavigationDestination(icon: Icon(Icons.person), label: "Profile"),          
          ],
        ),
      ),
    );
  }
}
class NavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;
  final List<StatefulWidget> screens = [
    const ActivityScreen(),
    const FollowingScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];
}

class BeehubDrawer extends StatelessWidget {
  const BeehubDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    Profile? profile = Provider.of<UserProvider>(context).ownprofile;
    if(profile == null){
      return Drawer(
        child:  Container(
          margin: const EdgeInsets.symmetric(vertical: 80,horizontal: 50),
          child: ListTile(leading: const Icon(Icons.exit_to_app), title: const Text("Back to Sign in"), onTap: ()=> DatabaseProvider().logOut(context),),
        ),
      );
    }
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            InkWell(
              onTap: () => Get.toNamed("/userpage/${profile.username}"),
              child: Container(
                padding: EdgeInsets.only(
                  top: 40 + MediaQuery.of(context).padding.top,
                  bottom: 24
                ),
                height: 220,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.5, 1),
                    colors: <Color>[
                      Color(0xff4f5261),
                      Color(0xff383a45),
                    ],
                    tileMode: TileMode.mirror,
                  ),
                ),  
                child: SizedBox(
                  height: 120,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black,width: 2.0),
                          borderRadius: BorderRadius.circular(35.0),
                          image:  DecorationImage(
                            fit: BoxFit.fill,
                            image: profile.image!.isNotEmpty? NetworkImage(profile.image!):
                          (profile.gender == 'female'?
                          const AssetImage("assets/avatar/user_female.png") as ImageProvider: const AssetImage("assets/avatar/user_male.png") as ImageProvider
                          ))
                        ),
                        width: 70,
                        height: 70,
                        child: const SizedBox(),
                      ),
                      // CircleAvatar(
                      //   backgroundColor: Colors.white,
                      //   radius: 35,
                      //   child: profile.image!.isNotEmpty? 
                      //   Image.network(profile.image!,height: 70,width: 70,fit: BoxFit.fill)
                      //   : profile.gender=='female'? Image.asset("assets/avatar/user_female.png",height: 70,width: 70,fit: BoxFit.fill):Image.asset("assets/avatar/user_male.png",height: 70,width: 70,fit: BoxFit.fill),
                      // ),
                      const SizedBox(height: 4,),
                      Text(profile.fullname, style: GoogleFonts.ubuntu(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),),
                      Text("@${profile.username}",style: GoogleFonts.ubuntu(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w400))
                    ],
                  ),
                ),      
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24,vertical: 10),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title:  Text("Activity",style: GoogleFonts.ubuntu(),),
                    onTap: ()=>Get.toNamed("/"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: Text("Friends",style: GoogleFonts.ubuntu()),
                    onTap: ()=> Get.toNamed("/userpage/friend_group/${profile.username}"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text("Settings",style: GoogleFonts.ubuntu()),
                    onTap: ()=>Get.toNamed("/account_setting"),
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: Text("Logout",style: GoogleFonts.ubuntu()),
                    onTap:()=> DatabaseProvider().logOut(context)
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
