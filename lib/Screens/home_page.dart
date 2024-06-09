import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Screens/activity_screen.dart';
import 'package:beehub_flutter_app/Screens/following_screen.dart';
import 'package:beehub_flutter_app/Screens/profile_page.dart';
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
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beehub'),
        actions: [
          IconButton(onPressed: (){}, icon:const Icon(Icons.search)),
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                ///logout
                DatabaseProvider().logOut(context);
              }),
        ],
      ),
      body: Obx(()=>controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        ()=> NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index){
            controller.selectedIndex.value = index;
          },
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
    Container(color: Colors.orangeAccent,),
    const ProfilePage(),
    // Container(color: Colors.redAccent,),
  ];
}
