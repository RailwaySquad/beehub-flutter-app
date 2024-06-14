import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/requirement.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:flutter/material.dart';
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
      list.addAll(listReq!);

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
    // if(list.isEmpty){
    //   return Padding(
    //     padding: const EdgeInsets.all(20),
    //     child: Center(child: Text("You have 0 notification for now",style: Theme.of(context).textTheme.headlineSmall)));
    // }
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
            return ListTile(
              leading: GestureDetector(
                onTap: (){},
                child: list[index].sender!.image!=null? Image.network(list[index].sender!.image!): (list[index].sender!.gender=='female'? Image.asset("assets/avatar/user_female.png"):Image.asset("assets/avatar/user_male.png")),
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
                  IconButton(onPressed: (){}, icon: const Icon(Icons.check, size: 20,color: Colors.green,)),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.close, size: 20, color:  Colors.red,))
                ],),
              );
          }),
      ],
    );
  }
}