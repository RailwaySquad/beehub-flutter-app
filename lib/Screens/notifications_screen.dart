import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/requirement.dart';
import 'package:beehub_flutter_app/Models/requirementForm.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Requirement> list = [];
  bool isLoading=false;
  Future fetchNotification()async{
    if(isLoading) return;
    isLoading = true;
    List<Requirement>? listReq = await THttpHelper.getNotification();
    setState(() {
      isLoading = false;
      list = listReq ?? [];
    });
  }
  @override
  void initState() {
    super.initState();
    fetchNotification();
  }
  
  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return const Padding(
        padding:  EdgeInsets.all(10.0),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(TColors.buttonPrimary),
          ),
        ),
      );
    }
    return Column(
      children: [
        AppBar(
           elevation: 10,
          title: Text("Notifications: ${list.length}"),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index){
            if(list[index].group==null && !list[index].isAccept!){
              return ListTile(
                leading: GestureDetector(
                  onTap: (){
                    Get.toNamed("/userpage/${list[index].sender!.username}");
                  },
                  child:
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black,width: 1.0),
                      borderRadius: BorderRadius.circular(45.0),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: list[index].sender!.image!=null? NetworkImage(list[index].sender!.image!)
                                  : (list[index].sender!.gender=='female'? const AssetImage("assets/avatar/user_female.png") as ImageProvider:const AssetImage("assets/avatar/user_male.png") as ImageProvider),)
                    ),
                    width: 60,
                    height: 60,
                  ),
                  
                ),
                title: RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(text: list[index].sender!.fullname, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const TextSpan(text: " send an add friend request"),
                                  ]
                              )),  
                subtitle: Text(list[index].createAt!=null&& DateTime.now().difference(list[index].createAt!)>const Duration(days: 1) ? DateFormat.yMMMMd('en_US').format(list[index].createAt!).toString() : "${DateTime.now().difference(list[index].createAt!).inHours.toString()} hours ago"),
                trailing: Wrap(
                  spacing: 12,
                  children: <Widget>[
                    IconButton(onPressed:  () async{
                      int idUser = await DatabaseProvider().getUserId();
                      Requirementform req = Requirementform(senderId: list[index].sender!.id, receiverId: idUser, type: "ACCEPT");
                      var response = await THttpHelper.createRequirement(req);
                      if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                        await fetchNotification();
                      }
                    }, icon: const Icon(Icons.check, size: 20,color: Colors.green,)),
                    IconButton(onPressed: () async{
                      int idUser = await DatabaseProvider().getUserId();
                      Requirementform req = Requirementform(senderId: list[index].sender!.id, receiverId: idUser, type: "CANCEL_ADDFRIEND");
                      var response = await THttpHelper.createRequirement(req);
                      if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                        await fetchNotification();
                      }
                    }, icon: const Icon(Icons.close, size: 20, color:  Colors.red,))
                  ],),
                );
            }
            if(list[index].group==null && list[index].isAccept!){
              return GestureDetector(
                onTap: (){
                  Get.toNamed("/userpage/${list[index].sender!.username}");
                },
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black,width: 1.0),
                      borderRadius: BorderRadius.circular(45.0),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: list[index].sender!.image!=null? NetworkImage(list[index].sender!.image!)
                                  : (list[index].sender!.gender=='female'? const AssetImage("assets/avatar/user_female.png") as ImageProvider:const AssetImage("assets/avatar/user_male.png") as ImageProvider),)
                    ),
                    width: 60,
                    height: 60,
                  ),
                  title: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(text: list[index].sender!.fullname, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: " now become your friend"),
                          ]
                        )),
                  trailing: IconButton(onPressed: ()async {
                    Requirementform req = Requirementform(senderId: list[index].sender!.id,id: list[index].id, type: "REMOVE_NOTIFICATION");
                    var response = await THttpHelper.createRequirement(req);
                    if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                      await fetchNotification();
                    }
                  }, icon: const Icon(Icons.remove)),
                ),
              );
            }
            if(list[index].receiverId==null && list[index].group!=null){
              return GestureDetector(
                onTap: (){
                    Get.toNamed("/group/${list[index].group!.id}");
                  },
                child: ListTile(
                  leading: 
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black,width: 1.0),
                      borderRadius: BorderRadius.circular(45.0),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: list[index].group!.imageGroup!=null? NetworkImage(list[index].group!.imageGroup!)
                                  : const AssetImage("assets/avatar/group_image.png") as ImageProvider,)
                    ),
                    width: 60,
                    height: 60,
                  ),
                  title: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(text: list[index].group!.groupname, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const TextSpan(text: " accept you join the group"),
                                    ]
                                )),  
                  subtitle: Text(list[index].createAt!=null&& DateTime.now().difference(list[index].createAt!)>const Duration(days: 1) ? DateFormat.yMMMMd('en_US').format(list[index].createAt!).toString() : "${DateTime.now().difference(list[index].createAt!).inHours.toString()} hours ago"),
                   trailing: IconButton(onPressed: ()async {
                    int idUser = await DatabaseProvider().getUserId();
                    Requirementform req = Requirementform(senderId: idUser,id: list[index].id, type: "REMOVE_NOTIFICATION");
                    var response = await THttpHelper.createRequirement(req);
                    if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                      await fetchNotification();
                    }
                  }, icon: const Icon(Icons.remove)),
                ),
              );
            }
            return const SizedBox();
            
          }),
      ],
    );
  }
}