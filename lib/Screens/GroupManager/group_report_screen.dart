import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/report.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Utils/beehub_button.dart';
import 'package:beehub_flutter_app/Utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupReportScreen extends StatefulWidget {
  const GroupReportScreen({super.key});

  @override
  State<GroupReportScreen> createState() => _GroupReportScreenState();
}

class _GroupReportScreenState extends State<GroupReportScreen> {
  List<Report> list=[];

  @override
  Widget build(BuildContext context) {
    Group? group = Provider.of<UserProvider>(context).group;
     if(group==null){
      return  const SizedBox();
    }
    list = group.reportsOfGroup!;
    
    if(list.isEmpty){
      return Center(
        heightFactor: 100,
        child:  Text("Found 0 report in group.", style: Theme.of(context).textTheme.titleLarge,),
      );
    }
    String formatDate(DateTime? date){
      if(date == null) return '';
      final now = DateTime.now();
      final difference = now.difference(date);
      if(difference.inDays > 365){
        final years = (difference.inDays / 365).floor();
        return '$years year ago'; 
      }else if(difference.inDays >= 30){
        final months = (difference.inDays / 30).floor();
        return '$months month ago';
      }else if(difference.inDays >= 1){
        return '${difference.inDays} day ago';
      }else if(difference.inHours >= 1){
        return '${difference.inHours} hours ago';
      }else if(difference.inMinutes >= 1){
        return '${difference.inMinutes} minutes ago';
      }else{
        return 'Now' ;
      }
    }
    return ListView.builder(
      itemCount: list.length,
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context,index){
        return Card(
          elevation: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            height: list[index].targetPost!.medias !=null? 400: 250 ,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: ()=> Get.toNamed("/userpage/${list[index].sender.username}"),
                  child: SizedBox(
                    width: THelperFunction.screenWidth(),
                    child: Row(
                      children: [
                        Container(
                          decoration:  BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black,width: 1.0),
                              borderRadius: BorderRadius.circular(25.0),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: list[index].sender.image!=null? NetworkImage(list[index].sender.image!)
                                          : (list[index].sender.gender == 'female'? const AssetImage("assets/avatar/user_female.png") as ImageProvider:const AssetImage("assets/avatar/user_male.png") as ImageProvider),)
                            ),
                          width: 50,
                          height: 50,
                        ),
                        const SizedBox(width: 8,),
                        Flexible(
                          flex: 3,
                          child: RichText(
                            maxLines: 2,
                            softWrap: true,
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style.copyWith(fontSize: 18),
                              children: [
                                TextSpan(text: list[index].sender.fullname, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const TextSpan(text: " report post in group."),
                                ]
                            )),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextButton(onPressed: (){
                              showAlertDialog( context,group.id!, list[index].id);
                            }, child:const Text("Reply")),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                              children: [
                                const TextSpan(text: "Report post of member: "),
                                TextSpan(text: list[index].targetPost!.userFullname, style: const TextStyle(fontWeight: FontWeight.bold)),
                                ]
                            )
                          ),
                      RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                              children: [
                                const TextSpan(text: "Report type: "),
                                TextSpan(text: list[index].type.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                ]
                            )
                          ),
                      Text("Report created at: ${formatDate(list[index].createAt)}"),
                      Text(list[index].addDescription!.isNotEmpty? "Add Description: ${list[index].addDescription!}":"No description" ),
                      const Text("Post content: " ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(list[index].targetPost!.text),
                              list[index].targetPost?.medias!=null? Image.network(list[index].targetPost!.medias!,height: 120,):const SizedBox(height: 9,),
                              Text("Created at: ${formatDate(list[index].targetPost!.createdAt!)}")
                            ],
                          ),
                        ),
                      )
                    ],))
              ],
            ),
          ),
        );
    });
  }
}
showAlertDialog(BuildContext context,int groupId, int reportId) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("Confirm Report"),
    content: const Text("If you accept this report, The report post will be delete. "),
    actions: [
      BeehubButton.AcceptReport(groupId, reportId),
      BeehubButton.RemoveReport(groupId, reportId)
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}