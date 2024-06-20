import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Models/group.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ListGroup extends StatelessWidget {
  const ListGroup({super.key});

  @override
  Widget build(BuildContext context) {
     bool isLoading = Provider.of<UserProvider>(context).isLoading;
    if(isLoading){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    List<Group> list= Provider.of<UserProvider>(context).groups;
    return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      itemBuilder: ( context, index){
        return ListTile(
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
                        image: list[index].imageGroup!=null? NetworkImage( list[index].imageGroup!)
                                  : const AssetImage("assets/avatar/group_image.png") as ImageProvider,)
                    ),
                    width: 60,
                    height: 60,
                  ),
          ),
          title: GestureDetector(
            onTap: (){
              Get.toNamed("/group/${list[index].id}");
            },
            child: Text(list[index].groupname)),
        );
      },
    );
  }
}