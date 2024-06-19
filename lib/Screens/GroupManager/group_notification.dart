import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/requirement.dart';
import 'package:beehub_flutter_app/Models/requirementForm.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupNotification extends StatefulWidget {
  const GroupNotification({super.key});

  @override
  State<GroupNotification> createState() => _GroupNotificationState();
}

class _GroupNotificationState extends State<GroupNotification> {
  List<Requirement> list =[];
  @override
  Widget build(BuildContext context) {
    Group? group = Provider.of<UserProvider>(context,listen: false).group;
    if(group==null){
      return  const SizedBox();
    }
    list= group.requirements!;
    Future<void> refresh() async {
      await Provider.of<UserProvider>(context, listen: false).fetchGroup(group.id!);  
      Group? groupf = Provider.of<UserProvider>(context,listen: false).group;
      setState(() {
        list = groupf!.requirements!;
      });
    }
    if(list.isEmpty){
      return Center(
        heightFactor: 100,
        child:  Text("Found 0 the join request.", style: Theme.of(context).textTheme.titleLarge,),
      );
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context,index){
        return ListTile(
                leading: GestureDetector(
                  onTap: (){
                    Get.toNamed("/userpage/${list[index].sender!.username}");
                  },
                  child: list[index].sender!.image!=null && list[index].sender!.image!.isNotEmpty
                    ? Image.network(list[index].sender!.image!): (list[index].sender!.gender=='female'? Image.asset("assets/avatar/user_female.png"):Image.asset("assets/avatar/user_male.png")),
                ),
                title: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(text: list[index].sender!.fullname, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const TextSpan(text: " want to join group."),
                                  ]
                              )),  
                subtitle: Text(list[index].createAt!=null&& DateTime.now().difference(list[index].createAt!)>const Duration(days: 1) ? DateFormat.yMMMMd('en_US').format(list[index].createAt!).toString() : "${DateTime.now().difference(list[index].createAt!).inHours.toString()} hours ago"),
                trailing: Wrap(
                  spacing: 12,
                  children: <Widget>[
                    IconButton(onPressed:  () async{
                      Requirementform req = Requirementform(senderId: list[index].sender!.id,receiverId:  list[index].sender!.id, groupId: group.id, type: "ACCEPT_MEMBER");
                      var response = await THttpHelper.createRequirement(req);
                      if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                        await refresh();
                      }
                    }, icon: const Icon(Icons.check, size: 20,color: Colors.green,)),
                    IconButton(onPressed: () async{
                      Requirementform req = Requirementform(senderId: list[index].sender!.id,receiverId:  list[index].sender!.id, groupId: group.id, type: "REJECT");
                      var response = await THttpHelper.createRequirement(req);
                      if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                         await refresh();
                      }
                    }, icon: const Icon(Icons.close, size: 20, color:  Colors.red,))
                  ],),
                );
      });
  }
}