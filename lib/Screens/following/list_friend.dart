import 'package:beehub_flutter_app/Constants/color.dart';
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
        child: CircularProgressIndicator(color: TColors.buttonPrimary,),
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
