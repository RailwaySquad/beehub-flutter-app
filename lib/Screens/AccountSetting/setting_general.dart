import 'dart:developer';
import 'dart:io';

import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/profile_form.dart';
import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:beehub_flutter_app/Utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class SettingGeneral extends StatefulWidget {
  const SettingGeneral({super.key});

  @override
  State<SettingGeneral> createState() => _SettingGeneralState();
}

class _SettingGeneralState extends State<SettingGeneral> {
  DateTime? selectedDate;
  File? _fileAvatar;
  File? _fileBg;
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
          if(_fileBg!=null){
            final upload = await THttpHelper.uploadBackground(_fileBg!);
            log("Upload Bg: $upload");
          }
          if(_fileAvatar!=null){
              final upload = await THttpHelper.uploadAvatar(_fileAvatar!);
              log("Upload Img: $upload");
          }
         if(formKey.currentState!.validate()){
            String fullname = fullnameInputController.text;
            String phone = phoneInputController.text;
            String gender = genderController.text;
            String biography = bioController.text;

            int id = int.parse(idInputController.text);
            DateFormat formatD = DateFormat('yyyy-MM-dd');
            String update= selectedDate!=null? formatD.format(selectedDate!):formatD.format(DateTime.now()); 
            Profileform data = Profileform(id: id,gender: gender, bio: biography, birthday: update,fullname: fullname,phone: phone );
            return await THttpHelper.updateProfile(data);
         }else{
          return false;
         }
      }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);},icon: const Icon(Icons.chevron_left),),
        title:  Text("Account Setting",style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(onPressed: ()async  {
                      if(formKey.currentState!.validate()){
                        bool result= await submitData();
                        if(result){
                          Provider.of<UserProvider>(context, listen: false).fetchProfile(true);
                          Navigator.popAndPushNamed(context, "/");
                        }else{
                          log(result.toString());
                        }
                      }
                    }, child: Text("Save", style: GoogleFonts.ubuntu(fontSize: 18)))
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
                        GestureDetector(
                           onTap: ()async{
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                if(image!=null){
                                  setState(() {
                                    _fileBg = File(image.path);
                                  });
                                }
                            },
                          child: Container(
                              decoration: const BoxDecoration(
                                border:  Border(bottom: BorderSide(color: TColors.secondary,width: 2.0))
                              ),
                            height: 180,
                            width: THelperFunction.screenWidth(),
                            child: Container(
                              color:TColors.darkerGrey,
                              child: _fileBg!=null? Image.file(_fileBg!, fit: BoxFit.fill,) :prof.background!.isNotEmpty? Image.network(prof.background!): const SizedBox(),
                              ),
                          ),
                        ),
                        Positioned(
                          top: 130, 
                          left: 20,
                          child: GestureDetector(
                            onTap: () async{
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                                if(image!=null){
                                  setState(() {
                                    _fileAvatar = File(image.path);
                                  });
                                  
                                }
                              },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black,width: 2.0),
                                borderRadius: BorderRadius.circular(45.0),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: _fileAvatar!=null? 
                                FileImage(_fileAvatar!) as ImageProvider
                                :prof.image!.isNotEmpty? NetworkImage(prof.image!):
                                (profile.gender == 'female'?
                                const AssetImage("assets/avatar/user_female.png") as ImageProvider: const AssetImage("assets/avatar/user_male.png") as ImageProvider
                                ),)
                              ),
                              width: 90,
                              height: 90,
                              child: const SizedBox()
                            ),
                          ),
                        ),
                      ]
                    ),
                const SizedBox(height: 50,),
                TextFormField(
                        controller: fullnameInputController,
                        decoration: const InputDecoration(
                          labelText: "Full name",
                        ),
                        validator: (value){
                          if(value!=null &&value.trim().isEmpty){
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
                          if(value!=null && value.trim().isEmpty){
                            return "Enter Phone number";
                          }else if(!regExp.hasMatch(value!)){
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
