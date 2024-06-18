import 'dart:developer';

import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/group_member.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
    if(list==null){
      return const SliverToBoxAdapter (
        child: Text("There are 0 member in group.")
      );
    }
    log(list.length.toString());
    return SliverList.builder(
      itemCount: list.length,
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: (){
              Get.toNamed('/userpage/${list[index].username}');
            },
          child: ListTile(
            leading: list[index].userImage!=null && list[index].userImage!.isNotEmpty
                    ? Image.network(list[index].userImage!)
                    : (list[index].userGender=='female'
                        ? Image.asset("assets/avatar/user_female.png") :Image.asset("assets/avatar/user_male.png")),
            title:  Text(list[index].userFullname!),
            subtitle: Text(list[index].role!.split("_").join(" ").toLowerCase()),
          ),
        ); 
      });
  }
}