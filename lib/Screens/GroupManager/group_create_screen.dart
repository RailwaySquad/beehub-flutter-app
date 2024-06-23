import 'package:beehub_flutter_app/Models/group_form.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupCreateSreen extends StatefulWidget {
  const GroupCreateSreen({super.key});

  @override
  State<GroupCreateSreen> createState() => _GroupCreateSreenState();
}

class _GroupCreateSreenState extends State<GroupCreateSreen> {
  final formKey = GlobalKey<FormState>();
    TextEditingController _nameInputController = TextEditingController();
    TextEditingController _descriptionInputController = TextEditingController();
    bool groupStatus = true;
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

    
  @override
  Widget build(BuildContext context) {
    Future<void> submitData () async{
      if(formKey.currentState!.validate()){
        String groupName = _nameInputController.text;
        String description = _descriptionInputController.text;
        GroupForm groupCreate = GroupForm(groupname:groupName,description: description,publicGroup:  groupStatus);
        final res=  await THttpHelper.createGroup(groupCreate);
        if(res!=0){
          Get.toNamed("/group/$res");
        }
      }
      }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left), onPressed: ()=> Navigator.pop(context),),
        title: const Text("Create Group"),
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
                          value: groupStatus,
                          onChanged: (value){
                          setState(() {
                            groupStatus = value!;
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