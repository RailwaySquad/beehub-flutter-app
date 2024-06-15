import 'dart:developer';

import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Screens/Activity/activity_screen.dart';
import 'package:beehub_flutter_app/Screens/Following/following_screen.dart';
import 'package:beehub_flutter_app/Screens/notifications_screen.dart';
import 'package:beehub_flutter_app/Screens/Profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      Provider.of<UserProvider>(context, listen: false).getUsername();
      String? user = Provider.of<UserProvider>(context, listen: false).username;
      log(user.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  final screens = [
    const ActivityScreen(),
    const FollowingScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
    // Container(color: Colors.redAccent,),
  ];
}
