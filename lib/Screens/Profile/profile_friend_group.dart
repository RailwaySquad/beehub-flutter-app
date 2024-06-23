import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Models/user.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfileFriendGroup extends StatefulWidget {
  const ProfileFriendGroup({super.key});

  @override
  State<ProfileFriendGroup> createState() => _ProfileFriendGroupState();
}

class _ProfileFriendGroupState extends State<ProfileFriendGroup> with SingleTickerProviderStateMixin  {
  late final TabController _tabController;
  final List<Tab> _tabs = const [
    Tab(text: "Friends",),
    Tab(text: "Groups",),
  ];
  final List<Widget> _tabsBody = [
    const ListFriendProfile(),
    const ListGroupProfile()
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
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left) ,onPressed: ()=> Navigator.pop(context),),
        title: Text("Following", style: GoogleFonts.ubuntu(fontSize: 22),),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
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
        )
    );
  }
}

class ListGroupProfile extends StatelessWidget {
  const ListGroupProfile({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoading = Provider.of<UserProvider>(context).isLoading;
    if(isLoading){
      return const Center(
        child: CircularProgressIndicator(color: TColors.buttonPrimary,),
      );
    }
    Profile? profile = Provider.of<UserProvider>(context).profile;
    if(profile==null){
      return const Center(
        child: Text("Not Found"),
      );
    }
    List<Group>? list = profile.groupJoined;
    if(list !=null){
      return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      itemBuilder: ( context, index){
        return ListTile(
          onTap: ()=>Get.toNamed("/group/${list[index].id}"),
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          leading: GestureDetector(
            onTap: (){
              Get.toNamed("/group/${list[index].id}");
            },
            child:
            Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black,width: 1.0),
                      borderRadius: BorderRadius.circular(45.0),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: list[index].imageGroup!=null? NetworkImage(list[index].imageGroup!)
                                  : const AssetImage("assets/avatar/group_image.png") as ImageProvider,)
                    ),
                    width: 60,
                    height: 60,
                  ),
          ),
          title: Text(list[index].groupname),
          trailing: const Icon(Icons.chevron_right),
        );
      },
    );
    }
    return const SizedBox();
  }
}  
class ListFriendProfile extends StatelessWidget {
  const ListFriendProfile({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoading = Provider.of<UserProvider>(context).isLoading;
    Profile? profile = Provider.of<UserProvider>(context, listen: false).profile;
    
    if(isLoading){
      return const Center(
        child: CircularProgressIndicator(color: TColors.buttonPrimary,),
      );
    }
    if(profile==null||profile.relationships ==null){
      return  Center(
        heightFactor: 100,
        child: Text("Not Found", style: Theme.of(context).textTheme.titleMedium,),
      );
    }
    int idUser = Provider.of<DatabaseProvider>(context).userId;
    bool checkSetting(){
      if(idUser==profile.id ){
        return true;
      }
      bool notSetting = true;
      if(profile.userSettings!.isNotEmpty){
        for (var element in profile.userSettings!) {
          if (element.settingItem=="list_friend" &&( element.settingType == "PUBLIC" || (idUser!=profile.id && profile.relationshipWithUser == "FRIEND" && element.settingType=="FOR_FRIEND")) ) {
            notSetting = true;
            break;
          }else if(element.settingItem=="list_friend" && (profile.relationshipWithUser==null || profile.relationshipWithUser!.isEmpty ||element.settingType == "HIDDEN" )){
            notSetting =  false;
          }
          notSetting = false;
        }
      }
      return notSetting ;
    }
    List<User>? listRel = profile.relationships;
    List<User> list=  listRel!=null && listRel.length>0? listRel.where((e)=> e.typeRelationship!="BLOCKED" && e.typeRelationship!="BE_BLOCKED").toList() :[];
    if(!checkSetting()){
      return Center(
        heightFactor: 50,
        child: Text("You have no permission to see list friend", style: Theme.of(context).textTheme.titleMedium,),
      );
    }
      return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      itemBuilder: ( context, index){
        return ListTile(
          onTap: ()=>Get.toNamed("/userpage/${list[index].username}"),
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          leading: GestureDetector(
            onTap: (){
              Get.toNamed("/userpage/${list[index].username}");
            },
            child:
            Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black,width: 1.0),
                      borderRadius: BorderRadius.circular(45.0),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: list[index].image!=null? NetworkImage(list[index].image!)
                                  : (list[index].gender == 'female'? const AssetImage("assets/avatar/user_female.png") as ImageProvider:const AssetImage("assets/avatar/user_male.png") as ImageProvider),)
                    ),
                    width: 60,
                    height: 60,
                  ),
          ),
          title: Text(list[index].fullname),
          trailing: const Icon(Icons.chevron_right),
        );
      },
    );
    
  }
}