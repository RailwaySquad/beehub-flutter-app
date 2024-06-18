import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/ProfileForm.dart';
import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:beehub_flutter_app/Utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class AccountSettingPage extends StatefulWidget {
  const AccountSettingPage({super.key});

  @override
  State<AccountSettingPage> createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  DateTime? selectedDate;
  File? _file;
  void _showDatePicker(DateTime? birthday){
    showDatePicker(
      context: context,
      initialDate: birthday?? DateTime.now(), 
      firstDate: DateTime(1900), 
      lastDate: DateTime.now(),
    ).then((value){
      if(value==null){
        return;
      }
      setState(() {
        log(value.toString());
      selectedDate = value;

      });
        log(selectedDate.toString());
    });
  }
  Future<void> _pickFile() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _file = File(pickedFile.path);
          // _isButtonEnabled = true;
        });
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    Profile? prof = Provider.of<UserProvider>(context, listen: false).ownprofile;
    bool isLoading = Provider.of<UserProvider>(context).isLoading;
    if( isLoading|| prof==null){
      return const Center(
        heightFactor: 300,
        child: CircularProgressIndicator(
          color: TColors.buttonPrimary,
        ),
      );
    }
    Profileform profile = Profileform.form(prof);
    final formKey = GlobalKey<FormState>();
    final TextEditingController fullnameInputController = TextEditingController(text: profile.fullname);
    final TextEditingController phoneInputController = TextEditingController(text: profile.phone);
    final TextEditingController idInputController = TextEditingController(text: profile.id.toString());
    final TextEditingController genderController = TextEditingController(text: profile.gender);
    final TextEditingController bioController = TextEditingController(text: profile.bio);
    
    Future<bool> submitData () async{
        String fullname = fullnameInputController.text;
        // String email = emailInputController.text;
        // String username =usernameInputController.text;
        String phone = phoneInputController.text;
        String gender = genderController.text;
        String biography = bioController.text;

        int id = int.parse(idInputController.text);
        DateFormat formatD = new DateFormat('yyyy-MM-dd');
        String update= selectedDate!=null? formatD.format(selectedDate!):formatD.format(DateTime.now()); 
        Profileform data = Profileform(id: id,gender: gender, bio: biography, birthday: update,fullname: fullname,phone: phone );
        log(data.toString());
        return THttpHelper.updateProfile(data);
      }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Get.toNamed("/");},icon: const Icon(Icons.chevron_left),),
        title: const Text("Account Setting"),
        actions: [
          TextButton(onPressed: ()async  {
                      if(formKey.currentState!.validate()){
                        bool result= await submitData();
                        if(result){
                          Provider.of<UserProvider>(context, listen: false).fetchProfile(true);
                          Get.toNamed('/');
                        }else{
                          log(result.toString());
                        }
                      }
                    }, child: const Text("Save"))
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                            decoration: const BoxDecoration(
                              border:  Border(bottom: BorderSide(color: TColors.secondary,width: 2.0))
                            ),
                          height: 180,
                          width: THelperFunction.screenWidth(),
                          child: Container(
                            color:TColors.darkerGrey,
                            child: prof.background!.isNotEmpty? Image.network(prof.background!): const SizedBox(),
                            ),
                        ),
                        Positioned(
                          top: 130, 
                          left: 20,
                          child: Container(
                            // color: Colors.white,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black,width: 2.0),
                              borderRadius: BorderRadius.circular(45.0),
                            ),
                            width: 90,
                            height: 90,
                            child: GestureDetector(
                              onTap: () async{
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                if(image!=null){
                                  Uint8List bytes = await image.readAsBytes();
                                  bool upload = await THttpHelper.uploadAvatar(_file!);
                                  log(upload.toString());
                                }
                              },
                              child: _file!=null? 
                              Image.file(_file!,fit: BoxFit.fill)
                              :prof.image!.isNotEmpty? Image.network(prof.image!,height: 75, width: 75,fit: BoxFit.fill):
                              (profile.gender == 'female'?
                              Image.asset("assets/avatar/user_female.png",height: 75, width: 75,fit: BoxFit.fill):Image.asset("assets/avatar/user_male.png",height: 75, width: 75,fit: BoxFit.fill)
                              ),)
                          ),
                        ),
                      ]
                    ),
                const SizedBox(height: 50,),
                TextFormField(
                  readOnly: true,
                  controller: idInputController,
                  decoration: const InputDecoration(label: Text("Id",style:  TextStyle(color: Colors.black87,fontSize: 13),),
                  floatingLabelAlignment: FloatingLabelAlignment.start ),
                ),
                TextFormField(
                        controller: fullnameInputController,
                        decoration: const InputDecoration(
                          labelText: "Full name",
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter Fullname";
                          }else{
                            return null;
                          }
                        },
                        
                      ),
                
                const SizedBox(height: 8,),
                TextFormField(
                        controller: phoneInputController,
                        decoration: const InputDecoration(
                          labelText: "Phone",
                        ),
                        validator: (value){
                          String pattern = r'(^(84|0[35789])+([0-9]{8})$)';
                          RegExp regExp =  RegExp(pattern);
                          if(value!.isEmpty){
                            return "Enter Phone number";
                          }else if(!regExp.hasMatch(value)){
                            return "Invalid Phone number \n(example: 8412345678 or 0912345678)";
                          }
                          return null;
                        },
                      ),
                const SizedBox(height: 8,),
                TextFormField(
                        maxLength: 200,
                        controller: bioController,
                        decoration: const InputDecoration(
                          labelText: "Biography",
                        ),
                        
                      ),
                const SizedBox(height: 8,),
                DropdownButtonFormField(
                   decoration: const InputDecoration(
                          labelText: "Gender",
                        ),
                  items:<String>["female","male"].map((gender)=> DropdownMenuItem(value: gender,child: Text(gender),)).toList(), 
                  value: profile.gender,
                  onChanged: (value){
                    genderController.text = value!;
                  }),
                
                const SizedBox(height: 8,),
                SizedBox(
                  height: 70,
                  child: Row(
                  children: <Widget>[
                      Expanded(child: Text(selectedDate==null? 'No Date Choosen': 'Picked Date: ${DateFormat.yMd().format(selectedDate!)}')),
                      TextButton(onPressed:() =>_showDatePicker(prof.birthday), child: const Text("Choose Date", style: TextStyle(fontWeight: FontWeight.bold),))
                    ],
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
