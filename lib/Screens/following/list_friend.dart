import 'package:beehub_flutter_app/Models/user.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ListFriend extends StatelessWidget {
  const ListFriend({super.key});
  @override
  Widget build(BuildContext context) {
    bool isLoading = Provider.of<UserProvider>(context).isLoading;
    if(isLoading){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    List<User> list= Provider.of<UserProvider>(context).friends;
    return ListView.builder(
      itemCount: list.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      itemBuilder: ( context, index){
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          leading: GestureDetector(
            onTap: (){
              Get.toNamed("/userpage/${list[index].username}");
            },
            child: list[index].image!=null
              ?Image.network(list[index].image!)
              : Image.asset( list[index].gender == 'female'? "assets/avatar/user_female.png":"assets/avatar/user_male.png"),
          ),
          title: GestureDetector(
            onTap: (){
              Get.toNamed("/userpage/${list[index].username}");
            },
            child: Text(list[index].fullname)),
        );
      },
    );
  }
}
