import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/report.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    Future<void> reFetch()async{
      await Provider.of<UserProvider>(context, listen: false).fetchGroup(group.id!);  
      Group? groupf = Provider.of<UserProvider>(context,listen: false).group;
      setState(() {
        list = groupf!.reportsOfGroup!;
      });
    }
    if(list.isEmpty){
      return Center(
        heightFactor: 100,
        child:  Text("Found 0 report in group.", style: Theme.of(context).textTheme.titleLarge,),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context,index){
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: ()=> Get.toNamed("/userpage/${list[index].sender.username}"),
                        child: SizedBox(
                          child: Row(
                            children: [
                              list[index].sender.image!=null? Image.network(list[index].sender.image!)
                                : (list[index].sender.gender=='female'? Image.asset("assets/avatars/user_female.png"): Image.asset("assets/avatar/user_male.png")),
                              const SizedBox(width: 8,),
                              Text(list[index].sender.fullname)
                            ],
                          ),
                        ),
                      ),
                      IconButton(onPressed: (){}, icon:const Icon(Icons.chevron_right))
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                              children: [
                                const TextSpan(text: "Report post of member: "),
                                TextSpan(text: list[index].sender.fullname, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                      Text(list[index].addDescription?? "No description" )
                    ],))
              ],
            ),
          );
      }),
    );
  }
}