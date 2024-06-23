import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/group_member.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class GroupPeople extends StatelessWidget {
  const GroupPeople({super.key});

  @override
  Widget build(BuildContext context) {
    Group? group = Provider.of<UserProvider>(context).group;

    if(group==null ){
      return const SliverToBoxAdapter (
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(
            TColors.buttonPrimary
          ),
        ),
      );
    }
    List<GroupMember>? list = group.groupMembers;
    if(list==null || list.isEmpty){
      return  SliverToBoxAdapter (
        child: Center(heightFactor: 4.0,child: Text("Not Found People",style: Theme.of(context).textTheme.headlineMedium))
      );
    }
    return SliverList.builder(
      itemCount: list.length,
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: (){
              Get.toNamed('/userpage/${list[index].username}');
            },
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black,width: 1.0),
                borderRadius: BorderRadius.circular(45.0),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: list[index].userImage!=null && list[index].userImage!.isNotEmpty
                      ? NetworkImage(list[index].userImage!)
                      : (list[index].userGender=='female'
                          ? const AssetImage("assets/avatar/user_female.png") as ImageProvider : const AssetImage("assets/avatar/user_male.png") as ImageProvider),)
              ),
              height: 60,
              width: 60,
            ),
            title:  Text(list[index].userFullname!),
            subtitle: Text(list[index].role!.split("_").join(" ").toLowerCase()),
          ),
        ); 
      });
  }
}