import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'email_update.dart';
import 'password_update.dart';
import 'username_update.dart';

class SettingAccount extends StatefulWidget {
  const SettingAccount({super.key});

  @override
  State<SettingAccount> createState() => _SettingAccountState();
}

class _SettingAccountState extends State<SettingAccount> {
  @override
  Widget build(BuildContext context) {
    Profile? profile = Provider.of<UserProvider>(context).ownprofile;
    if(profile==null){
      return const Center(
        child: CircularProgressIndicator(
          color: TColors.buttonPrimary,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left),onPressed: ()=>Navigator.pop(context),),
      ),
      body: ListView.custom(childrenDelegate: SliverChildListDelegate([
        ListTile(
          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>const UsernameUpdate())),
          title: const Text("Change Username"),
          trailing: const Icon(Icons.chevron_right),
        ),
        ListTile(
          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> const EmailUpdate())),
          title: const Text("Change Email"),
          trailing: const Icon(Icons.chevron_right),
        ),
        ListTile(
          onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> PasswordUpdate())),
          title: const Text("Change Password"),
          trailing: const Icon(Icons.chevron_right),
        ),
        GestureDetector(
          onTap: (){
          
          },
          child:const ListTile(
            title:  Text("Setting Posts"),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
        GestureDetector(
          onTap: (){
          
          },
          child:const ListTile(
            title:  Text("Setting Email"),
            trailing: Icon(Icons.chevron_right),
          ),
        ),
      ])),
    );
  }
}
