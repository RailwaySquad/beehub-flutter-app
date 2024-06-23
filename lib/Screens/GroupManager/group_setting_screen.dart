import 'dart:developer';
import 'dart:io';

import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/group_form.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class GroupSettingScreen extends StatefulWidget {
  const GroupSettingScreen({super.key});

  @override
  State<GroupSettingScreen> createState() => _GroupSettingScreenState();
}

class _GroupSettingScreenState extends State<GroupSettingScreen> {
    final formKey = GlobalKey<FormState>();
    TextEditingController _nameInputController = TextEditingController();
    File? _fileImg;
    File? _fileBg;
  
    @override
    void initState() {
      super.initState();
      _nameInputController.addListener(() {
        final String text = _nameInputController.text.trim();
        _nameInputController.value = _nameInputController.value.copyWith(
          text: text,
          selection:
              TextSelection(baseOffset: text.length, extentOffset: text.length),
          composing: TextRange.empty,
        );
      });
      _descriptionInputController.addListener(() {
        final String text = _descriptionInputController.text.trim();
        _descriptionInputController.value = _descriptionInputController.value.copyWith(
          text: text,
          selection:
              TextSelection(baseOffset: text.length, extentOffset: text.length),
          composing: TextRange.empty,
        );
      });
    }
    @override
    void dispose() {
      _nameInputController.dispose();
      _descriptionInputController.dispose();
      super.dispose();
    }
    TextEditingController _descriptionInputController = TextEditingController();
    bool? groupStatus;
    
  @override
  Widget build(BuildContext context) {
    Group? group = Provider.of<UserProvider>(context).group;
    if(group==null){
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon:const Icon(Icons.chevron_left),onPressed: ()=> Get.toNamed("/"),),
        ),
        body: Center(child: Text("Not found group", style: Theme.of(context).textTheme.bodyLarge,),),
      );
    }
    _nameInputController.text = group.groupname;
    _descriptionInputController.text = group.description??"";
    Future<void> submitData () async{
      if(_fileBg!=null){
        final uploadBg = await THttpHelper.uploadBackgroudGr(_fileBg!,group.id!);
          log(uploadBg.toString());
      }
      if(_fileImg!=null){
        final uploadImg = await THttpHelper.uploadImgGr(_fileImg!,group.id!);
        log(uploadImg.toString());
      }
        if(formKey.currentState!.validate()){
          String groupName = _nameInputController.text;
          String description = _descriptionInputController.text;
          int id = group.id!;
          GroupForm groupUpdate = GroupForm(id: id,groupname:groupName,description: description,publicGroup:  groupStatus??group.publicGroup);
          final res=  await THttpHelper.updateGroup(groupUpdate);
          if(res["result"]){
            Navigator.popAndPushNamed(context, "/group/$id");
          }

        }
      }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left), onPressed: ()=> Navigator.pop(context),),
        title: const Text("Group Setting"),
        actions: [
          TextButton(onPressed: ()async  {
                      if(formKey.currentState!.validate()){
                         await submitData();
                      }
                    }, child:  Text("Save", style: GoogleFonts.ubuntu(fontSize: 18),))
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Change background", style: TextStyle(fontSize: 18),),
              const SizedBox(height: 8,),
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
                child: group.backgroundGroup!=null? Image.network( group.backgroundGroup!,height: 160, fit: BoxFit.fill,)
                                                : _fileBg!=null? Image.file(_fileBg!,height: 160, fit: BoxFit.fill,) :Container(color: Colors.grey,height: 160,),
              ),
              const SizedBox(height: 10,),
              const Text("Change group image", style: TextStyle(fontSize: 18),),
              const SizedBox(height: 8,),
              GestureDetector(
                 onTap: ()async{
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if(image!=null){
                      setState(() {
                        _fileImg = File(image.path);
                      });
                      
                    }
                },
                child: group.imageGroup!=null? Image.network( group.imageGroup!,height: 160, width: 160, fit: BoxFit.fill)
                                               :_fileImg!=null?Image.file(_fileImg!, height: 160,width: 160, fit: BoxFit.fill): Container(color: Colors.grey,height: 160, width: 160,),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        const SizedBox(height: 10,),
                        const Text("Group name", style: TextStyle(fontSize: 18),),
                        const SizedBox(height: 8,),
                        TextFormField(
                          controller: _nameInputController,
                          validator: (val) {
                            if(val!=null&& val.trim().isEmpty){
                              return "Group name is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10,),
                        const Text("Group description", style: TextStyle(fontSize: 18),),
                        const SizedBox(height: 8,),
                        TextFormField(
                          maxLength: 200,
                          controller: _descriptionInputController,
                        ),
                        const SizedBox(height: 8,),
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                                  labelText: "Status Group",
                                ),
                          items:<bool>[true,false].map((status)=> DropdownMenuItem(value:status,child: Text(status ? "Public": "Private"),)).toList(), 
                          value: group.publicGroup,
                          onChanged: (value){
                          setState(() {
                            groupStatus = value;
                            log(groupStatus.toString());
                          });
                  }),
                
                    ],),
                ))
              
            ],
          ),),
      ),
    );
  }
}