import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GroupSettingScreen extends StatefulWidget {
  const GroupSettingScreen({super.key});

  @override
  State<GroupSettingScreen> createState() => _GroupSettingScreenState();
}

class _GroupSettingScreenState extends State<GroupSettingScreen> {
    final formKey = GlobalKey<FormState>();
    TextEditingController _nameInputController = TextEditingController();
    TextEditingController _descriptionInputController = TextEditingController();
    @override
    void initState() {
      super.initState();
      _nameInputController.addListener(() {
        final String text = _nameInputController.text.toLowerCase();
        _nameInputController.value = _nameInputController.value.copyWith(
          text: text,
          selection:
              TextSelection(baseOffset: text.length, extentOffset: text.length),
          composing: TextRange.empty,
        );
      });
      _descriptionInputController.addListener(() {
        final String text = _descriptionInputController.text.toLowerCase();
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left), onPressed: ()=> Navigator.pop(context),),
        title: const Text("Group Setting"),
        actions: [
          TextButton(onPressed: (){}, child:  Text("Save", style: GoogleFonts.ubuntu(fontSize: 18),))
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
                child: group.backgroundGroup!=null? Image.network( group.backgroundGroup!,height: 160, fit: BoxFit.fill,)
                                                : Container(color: Colors.grey,height: 160,),
              ),
              const SizedBox(height: 10,),
              const Text("Change group image", style: TextStyle(fontSize: 18),),
              const SizedBox(height: 8,),
              GestureDetector(
                child: group.imageGroup!=null? Image.network( group.imageGroup!,height: 160, width: 160, fit: BoxFit.fill,)
                                                : Container(color: Colors.grey,height: 160, width: 160,),
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
                            if(val!=null&& val.isEmpty){
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
                    ],),
                ))
              
            ],
          ),),
      ),
    );
  }
}