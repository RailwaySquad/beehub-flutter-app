import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/ProfileForm.dart';
import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EmailUpdate extends StatefulWidget {
  const EmailUpdate({super.key});

  @override
  State<EmailUpdate> createState() =>  _EmailUpdateState();
}

class _EmailUpdateState extends State<EmailUpdate> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _emailInputController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _emailInputController.addListener(() {
      final String text = _emailInputController.text.toLowerCase();
      _emailInputController.value = _emailInputController.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }
  @override
  void dispose() {
    _emailInputController.dispose();
    super.dispose();
  }
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
    _emailInputController.text = profile.email;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left),onPressed: ()=>Navigator.pop(context),),
        title:  Text("Change Email",style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, left: 15,right: 15),
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Require Login again after update email"),
              const SizedBox(height: 15,),
              TextFormField(
                decoration: const InputDecoration( 
                  labelText:"Email", 
                  labelStyle: TextStyle(fontSize: 16)
                ),
                controller: _emailInputController,
                validator: (val) {
                  if(val!=null&& val.isEmpty){
                    return "Email is required";
                  }
                  RegExp regExp = RegExp(r'^[\w.+\-]+@gmail\.com$');
                  if(!regExp.hasMatch(val!)){
                    return  "Email is invalid";
                  }
                  return null;
                }
              ),
              const SizedBox(height: 12,),
              Center(
                child: ElevatedButton(
                  onPressed: ()async{
                    bool checkEmail = await THttpHelper.checkEmail(_emailInputController.text);
                    if(checkEmail && _emailInputController.text!=profile.email){
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          content: Text("Email already taken"),
                                      ));
                    }
                    if(!checkEmail&& _emailInputController.text!=profile.email){ 
                     Profileform data = Profileform(id: profile.id,gender: profile.gender, bio: profile.bio,fullname: profile.fullname,phone: profile.phone, email: _emailInputController.text );
                      
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
