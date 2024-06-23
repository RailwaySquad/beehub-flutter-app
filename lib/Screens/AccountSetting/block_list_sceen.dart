import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Models/user.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Utils/beehub_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BlockListSceen extends StatefulWidget {
  const BlockListSceen({super.key});

  @override
  State<BlockListSceen> createState() => _BlockListSceenState();
}

class _BlockListSceenState extends State<BlockListSceen> {
  List<User> list=[];
  
  @override
  Widget build(BuildContext context) {
    Profile? profile = Provider.of<UserProvider>(context).ownprofile;
      if(profile==null){
        return Scaffold(
          appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.chevron_left),onPressed: ()=>Navigator.pop(context),),
          title: Text("Change Email",style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          body:const Center(child: CircularProgressIndicator(color: TColors.buttonPrimary,),),
        );
      }
    list = profile.relationships!.where((u)=> u.typeRelationship=='BLOCKED').toList();
    Future<void> reFetch()async{
      await Provider.of<UserProvider>(context, listen: false).fetchProfile(true);  
      Profile? prof = Provider.of<UserProvider>(context,listen: false).ownprofile;
      setState(() {
        list = prof!.relationships!.where((u)=> u.typeRelationship=='BLOCKED').toList();
      });
    }
    if(list.isEmpty){
      return Scaffold(
        appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left),onPressed: ()=>Navigator.pop(context),),
        title:  Text("List Blocked",style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        body:  Center(
          heightFactor: 4,
          child: Text("List blocked is empty",style: Theme.of(context).textTheme.headlineSmall),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left),onPressed: ()=>Navigator.pop(context),),
        title:  Text("List Blocked",style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index){
            return ListTile(
              leading: list[index].image!=null && list[index].image!.isNotEmpty
                        ? CircleAvatar(child: Image.network(list[index].image!, height: 70, width: 70, fit: BoxFit.fill,))
                        : list[index].gender=='female'? CircleAvatar(child: Image.asset("assets/avatar/user_female.png",height: 70, width: 70, fit: BoxFit.fill)):CircleAvatar(child: Image.asset("assets/avatar/user_male.png",height: 70, width: 70, fit: BoxFit.fill,)),
              title: Text(list[index].fullname),
              trailing: BeehubButton.UnBlock(list[index].id, "/account_setting/block", null,reFetch),
            );
          })),
    );
  }
}