import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingOption extends StatelessWidget {
  const SettingOption({super.key});
  @override
  Widget build(BuildContext context) {
    final Map<String, String> options= <String, String>{"General Setting": "/account_setting/general" ,"Account Setting": "/account_setting/account", "Security":"/account_setting/security" };
    final List<String> keysOp = ["General Setting","Account Setting","Security"];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Get.toNamed("/");},icon: const Icon(Icons.chevron_left),),
        title: Text("Account Setting",style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ListView.builder(
          itemCount: keysOp.length,
          itemBuilder: (context, index){
            return ListTile(
              onTap: (){
                Get.toNamed(options[keysOp[index]]!);
              },
              title: Text(keysOp[index]),
            );
          },
        ),
      ));
  }
}