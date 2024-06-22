import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Models/user_setting.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileAbout extends StatelessWidget {
  const ProfileAbout({super.key});

  @override
  Widget build(BuildContext context) {
    Profile? profile = Provider.of<UserProvider>(context).profile;
    int idUser = Provider.of<DatabaseProvider>(context).userId;
    if(profile ==null){
      return const SliverToBoxAdapter(child: Center(child: Text("Not Found")));
    }
    List<UserSetting> settings = profile.userSettings!;
    bool checkSetting(String type){
      if(idUser==profile.id ||profile.relationshipWithUser==null || profile.relationshipWithUser!.isEmpty){
        return true;
      }
      if(settings.isNotEmpty){
        UserSetting se = settings.firstWhere((el)=> el.settingItem==type );
        if(se.settingType == "PUBLIC "){
          return true;
        }else if(idUser!=profile.id && profile.relationshipWithUser == "FRIEND" && se.settingType=="FOR_FRIEND"){
          return true;
        }
      }
      return false;
    }
    
    return SliverToBoxAdapter(
            child:  Card(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Table(
                children: <TableRow>[
                  TableRow(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child:  Text("Full Name", style: Theme.of(context).textTheme.bodyLarge,)),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(  profile.fullname, style: Theme.of(context).textTheme.bodyLarge))
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(
                         padding: const EdgeInsets.all(8.0),
                         child: Text("Email", style: Theme.of(context).textTheme.bodyLarge,)),
                      Container( 
                        padding: const EdgeInsets.all(8.0),
                        child: Text( checkSetting("email") ?profile.email:"", style: Theme.of(context).textTheme.bodyLarge,))
                    ]
                  ),
                  TableRow(
                    children: [
                       Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Phone number", style: Theme.of(context).textTheme.bodyLarge)),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text( checkSetting("phone") ? profile.phone!:"", style: Theme.of(context).textTheme.bodyLarge))
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Gender", style: Theme.of(context).textTheme.bodyLarge)),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(checkSetting("gender") ?profile.gender:"", style: Theme.of(context).textTheme.bodyLarge))
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Birthday: ", style: Theme.of(context).textTheme.bodyLarge)),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(checkSetting("birthday") &&profile.birthday!=null
                        ?  DateFormat.yMMMd('en_US').format(profile.birthday!):"", style: Theme.of(context).textTheme.bodyLarge))
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Active at: ", style: Theme.of(context).textTheme.bodyLarge)),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: profile.createdAt!=null? Text(DateFormat.yMMMMd('en_US').format(profile.createdAt!), style: Theme.of(context).textTheme.bodyLarge): const Text(""))
                    ]
                  ),
                ],
              ),
            ) 
          );
  }
}