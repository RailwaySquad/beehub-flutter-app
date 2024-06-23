import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'list_friend.dart';
import 'list_group.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<Tab> _tabs = const [
    Tab(text: "Friends",),
    Tab(text: "Groups",),
  ];
  final List<Widget> _tabsBody = [
    const ListFriend(),
    const ListGroup()
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).fetchFriends();
      Provider.of<UserProvider>(context, listen: false).fetchGroups();
    });
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            AppBar(
              leading: const Icon(Icons.favorite_border, color: Colors.white,),
              backgroundColor:const Color(0xff383a45),
              title: Text('Following', style: GoogleFonts.ubuntu(color: Colors.white),),
                actions: [
                  ElevatedButton(
                    onPressed: ()=> Get.toNamed("/group_create"),
                    style: ButtonStyle(
                      foregroundColor:  WidgetStateProperty.all<Color>(const Color(0xff383a45)),
                      backgroundColor:  WidgetStateProperty.all<Color>(Colors.white),
                    ),
                    child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(Icons.add),
                      Text("Group", style: GoogleFonts.ubuntu(fontSize: 16),)
                    ]
                    )
                  )
                ],
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  TabBar(
                    controller:  _tabController,
                    tabs: _tabs
                    )
                ],
              ),
            ),
            Expanded(
              flex: 13,
              child: TabBarView(
                  controller: _tabController,
                  children: _tabsBody,),
              
              )
          ],
        );
  }
}
