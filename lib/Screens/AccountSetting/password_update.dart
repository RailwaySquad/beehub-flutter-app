import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PasswordUpdate extends StatefulWidget{
  @override
  State<PasswordUpdate> createState() => _PasswordUpdateState();
}

class _PasswordUpdateState extends State<PasswordUpdate> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _passwordInputController = TextEditingController();
  TextEditingController _confirmPasswordInputController = TextEditingController();
  // TextEditingController _currentPasswordInputController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _passwordInputController.addListener(() {
      final String text = _passwordInputController.text.toLowerCase();
      _passwordInputController.value = _passwordInputController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    _confirmPasswordInputController.addListener((){
      final String text = _confirmPasswordInputController.text.toLowerCase();
      _confirmPasswordInputController.value = _confirmPasswordInputController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    // _currentPasswordInputController.addListener((){
    //   final String text = _currentPasswordInputController.text.toLowerCase();
    //   _currentPasswordInputController.value = _currentPasswordInputController.value.copyWith(
    //     text: text,
    //     selection:
    //         TextSelection(baseOffset: text.length, extentOffset: text.length),
    //     composing: TextRange.empty,
    //   );
    // });
  }
  @override
  void dispose() {
    _passwordInputController.dispose();
    _confirmPasswordInputController.dispose();
    // _currentPasswordInputController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Profile? profile = Provider.of<UserProvider>(context).ownprofile;
    if(profile==null){
      return Scaffold(
        appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left),onPressed: ()=>Navigator.pop(context),),
        title: Text("Change Password",style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        body:const Center(child: CircularProgressIndicator(color: TColors.buttonPrimary,),),
      );
    }
    return Scaffold(
      appBar:  AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left),onPressed: ()=>Navigator.pop(context),),
        title: Text("Change Password",style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 15,right: 15),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Require Login again after update password"),
              const SizedBox(height: 15,),
              TextFormField(
                obscureText: true,
                autocorrect: false,
                decoration: const InputDecoration( 
                  labelText:"New Password", 
                  labelStyle: TextStyle(fontSize: 16)
                ),
                controller:_passwordInputController,
                validator: (val) {
                  if(val!=null&& val.isEmpty){
                    return "Password is required";
                  }
                  RegExp regExp =RegExp(r'^(?=.*?[a-zA-Z])(?=.*?[0-9]).{6,}$');
                  if(!regExp.hasMatch(val!)){
                    return  "New Password is invalid.\nPassword valid contains at least 1 character or 1 number, and can contain special characters. Password length is greater than 6.";
                  }
                  return null;
                }
              ),
              TextFormField(
                obscureText: true,
                autocorrect: false,
                decoration: const InputDecoration( 
                  labelText:"Confirn Password", 
                  labelStyle: TextStyle(fontSize: 16)
                ),
                controller:_confirmPasswordInputController,
                validator: (val) {
                  if(val!=null&& val.isEmpty){
                    return "Password confirm is required.";
                  }
                  if(val!=_passwordInputController.text){
                    return  "Confirm passwords do not match New password.";
                  }
                  return null;
                }
              ),
              // TextFormField(
              //   obscureText: true,
              //   autocorrect: false,
              //   decoration: const InputDecoration( 
              //     labelText:"Current Password", 
              //     labelStyle: TextStyle(fontSize: 16)
              //   ),
              //   controller:_currentPasswordInputController,
              //   validator: (val) {
              //     if(val!=null&& val.isEmpty){
              //       return "Current Password is required";
              //     }
              //     return null;
              //   }
              // ),
              const SizedBox(height: 12,),
              Center(
                child: ElevatedButton(
                  onPressed: ()async{
                    // bool checkPassword = await THttpHelper.checkPassword(_currentPasswordInputController.text);
                    // log(checkPassword.toString());
                    // if(!checkPassword ){
                    //  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    //                       content: Text("Current Password incorrect"),
                    //                   ));
                    // }else{

                     if(formKey.currentState!.validate()){
                      bool resp= await THttpHelper.updatePassword(_passwordInputController.text); 
                      if(resp){
                        DatabaseProvider().logOut(context);
                      }
                     }
                  // }
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
