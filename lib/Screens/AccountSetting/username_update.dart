import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/ProfileForm.dart';
import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Screens/AccountSetting/setting_account.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsernameUpdate extends StatefulWidget {

  const UsernameUpdate({super.key});

  @override
  State<UsernameUpdate> createState() => _UsernameUpdateState();
}

class _UsernameUpdateState extends State<UsernameUpdate> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _userInputController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _userInputController.addListener(() {
      final String text = _userInputController.text.toLowerCase();
      _userInputController.value = _userInputController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }
  @override
  void dispose() {
    _userInputController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Profile? profile = Provider.of<UserProvider>(context).ownprofile;
    if(profile==null){
      return Scaffold(
        appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left),onPressed: ()=>Navigator.pop(context),),
        title: const Text("Change Username"),
        ),
        body:const Center(child: CircularProgressIndicator(color: TColors.buttonPrimary,),),
      );
    }
    _userInputController.text = profile.username;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left),onPressed: ()=>Navigator.pop(context),),
        title: const Text("Change Username"),
        ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 15,right: 15),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Require Login again after update username"),
              const SizedBox(height: 15,),
              TextFormField(
                controller: _userInputController,
                decoration:const InputDecoration(
                  labelText:"Username", 
                  labelStyle: TextStyle(fontSize: 16)
                ),
                validator: (val) {
                  if(val!=null&& val.isEmpty){
                    return "Username is required";
                  }
                  return null;
                },
                
              ),
              const SizedBox(height: 12,),
              Center(
                child: ElevatedButton(
                  onPressed: ()async{
                    bool checkUser = await THttpHelper.checkUsername(_userInputController.text);
                    if(checkUser && _userInputController.text!=profile.username){
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          content: Text("Username already taken"),
                                      ));
                    }
                    if(!checkUser&& _userInputController.text!=profile.username){ 
                     Profileform data = Profileform(id: profile.id,gender: profile.gender, bio: profile.bio,fullname: profile.fullname,phone: profile.phone, username: _userInputController.text );
                      bool resp= await THttpHelper.updateProfile(data); 
                      if(resp){
                        DatabaseProvider().logOut(context);
                      }
                    }
                  }, 
                  style:  ButtonStyle(
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                  backgroundColor: WidgetStateProperty.all<Color>(TColors.buttonPrimary),
                ),
                child: const Text("Save Change", style: TextStyle(fontWeight: FontWeight.w600),),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}