import 'package:flutter/material.dart';

class GroupManagement extends StatefulWidget {
  const GroupManagement({super.key});

  @override
  State<GroupManagement> createState() => _GroupManagementState();
}

class _GroupManagementState extends State<GroupManagement> with SingleTickerProviderStateMixin  {
  late final TabController _tabController;
  final List<Tab> _tabs = const [
    Tab(icon: Icon(Icons.notifications_active),),
    Tab(icon: Icon(Icons.people)),
    Tab(icon: Icon(Icons.report))
  ];
  final List<Widget> _tabsBody = [
    Container(color: Colors.blue,),
    Container(color: Colors.green,),
    Container(color: Colors.red,)
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    });
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            AppBar(
              title: const Text('Group Management'),
                actions: [
                  IconButton(onPressed: (){        
                  }, icon:const Icon(Icons.settings)),
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