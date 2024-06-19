import 'dart:developer';

import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/group_member.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Utils/beehub_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GroupMemberScreen extends StatefulWidget {
  const GroupMemberScreen({super.key});

  @override
  State<GroupMemberScreen> createState() => _GroupMemberScreenState();
}

class _GroupMemberScreenState extends State<GroupMemberScreen> {
  List<GroupMember> list=[];
  int? idUser ;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      int id=await Provider.of<DatabaseProvider>(context, listen: false).getUserId();
      setState(() {
        idUser = id;
      });
    }); 
  }
  @override
  Widget build(BuildContext context) {
    Group? group = Provider.of<UserProvider>(context).group;
    if(group==null){
      return  const SizedBox();
    }
    list = group.groupMembers!;
    Future<void> reFetch()async{
      await Provider.of<UserProvider>(context, listen: false).fetchGroup(group.id!);  
      Group? groupf = Provider.of<UserProvider>(context,listen: false).group;
      setState(() {
        list = groupf!.groupMembers!;
      });
    }
    Text getRole (String role) {
      switch (role) {
        case "GROUP_CREATOR":
          return Text("Group creator", style: GoogleFonts.ubuntu(color: Colors.red, fontWeight: FontWeight.bold,fontSize: 14),);
        case "GROUP_MANAGER":
          return Text("Group manager", style: GoogleFonts.ubuntu(color: Colors.green, fontWeight: FontWeight.bold,fontSize: 14));
        default:
          return Text("Member",style: GoogleFonts.ubuntu(color: Colors.grey, fontWeight: FontWeight.bold,fontSize: 14),);
      }
    }
    Widget getButton(GroupMember mem){
      switch (mem.role) {
        case "GROUP_CREATOR":
          return const SizedBox();
        case "GROUP_MANAGER":
          if(idUser==mem.userId){
           return  BeehubButton.RetireManager(group.id!, reFetch);
          }else{
            return BeehubButton.RemoveManager(group.id!, mem.userId, reFetch);
          }
        default:
          return  Row(
            crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
            children:[ 
            BeehubButton.SetManager(group.id!, mem.userId, reFetch), 
            const SizedBox(width: 5,),
            BeehubButton.RemoveMember(group.id!,mem.userId, reFetch)]);
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context,index){
          return ListTile(
            title: GestureDetector(
              onTap: ()=> Get.toNamed("/userpage/${list[index].username}"),
              child:  Text(list[index].userFullname!, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
              ),
            subtitle:getRole(list[index].role!),
            trailing: getButton(list[index])
          );
      }),
    );
  }
}