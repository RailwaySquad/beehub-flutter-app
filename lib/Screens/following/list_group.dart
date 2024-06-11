import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Models/group.dart';
import 'package:flutter/material.dart';
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
          leading: list[index].imageGroup!=null
            ?Image.network(list[index].imageGroup!)
            : Image.asset( "assets/avatar/group_image.png"),
          title: Text(list[index].groupname),
        );
      },
    );
  }
}