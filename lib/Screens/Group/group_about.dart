import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupAbout extends StatelessWidget {
  const GroupAbout({super.key});

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
    String dateCreate = group.createdAt!=null? DateFormat('dd/MM/yyyy').format(group.createdAt!):"";
    return  SliverToBoxAdapter(
              child:  Card(
                color: TColors.white,
                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text("Description", style: Theme.of(context).textTheme.titleLarge,),
                      const SizedBox(height: 6),
                        group.description!=null? Text(group.description!, style: Theme.of(context).textTheme.bodyMedium,): const SizedBox(),
                      const SizedBox(height: 20,),
                      Text("About Group", style: Theme.of(context).textTheme.titleLarge,),
                        ListTile(
                          leading: group.publicGroup? const Icon(CupertinoIcons.globe): const Icon(CupertinoIcons.lock),
                          title:  group.publicGroup? const Text("Public"): const Text("Private"),
                          subtitle: group.publicGroup? const Text("Everyone can see all posts in the group"): const Text("Just member can see all posts in the group."),
                        ),
                        ListTile(
                          leading: group.active? const Icon(CupertinoIcons.eye): const Icon(CupertinoIcons.eye_slash),
                          title:  group.active? const Text("Visible"): const Text("Invisible"),
                          subtitle: group.active? const Text("Everyone can find this group."): const Text("Everyone can's find this group."),
                        ),
                        ListTile(
                          leading: const Icon(CupertinoIcons.clock_fill),
                          title:   const Text("History"),
                          subtitle:   Text("Group created on $dateCreate"),
                        ),
                      ],
                  ),
                )
              ) 
            );
  }
}