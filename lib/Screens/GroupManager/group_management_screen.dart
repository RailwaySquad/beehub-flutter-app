import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Screens/GroupManager/group_member_screen.dart';
import 'package:beehub_flutter_app/Screens/GroupManager/group_notification.dart';
import 'package:beehub_flutter_app/Screens/GroupManager/group_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GroupManagementScreen extends StatefulWidget {
  const GroupManagementScreen({super.key});

  @override
  State<GroupManagementScreen> createState() => _GroupManagementScreenState();
}

class _GroupManagementScreenState extends State<GroupManagementScreen> with SingleTickerProviderStateMixin  {
  late final TabController _tabController;
  final List<Tab> _tabs = const [
    Tab(icon: Icon(Icons.notifications_active),),
    Tab(icon: Icon(Icons.people)),
    Tab(icon: Icon(Icons.report))
  ];
  final List<Widget> _tabsBody = [
    const GroupNotification(),
    const GroupMemberScreen(),
    const GroupReportScreen()
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Group? group = Provider.of<UserProvider>(context,listen: false).group;
    if( group==null){
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: ()=>Navigator.pop(context), icon: const Icon(Icons.chevron_left)),
          title: const Text("Group Management"),
        ),
      );
    }
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            AppBar(
              title: const Text('Group Management'),
                actions: [
                  IconButton(onPressed: ()=> Get.toNamed("/group/setting/${group.id}"), icon:const Icon(Icons.settings)),
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
        ),
    );
  }
}