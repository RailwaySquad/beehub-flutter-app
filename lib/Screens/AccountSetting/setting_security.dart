
import 'package:beehub_flutter_app/Utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingSecurity extends StatefulWidget {
  const SettingSecurity({super.key});

  @override
  State<SettingSecurity> createState() => _SettingSecurityState();
}

List<String> optionts = ["Option", "Public", "For Friend","Private"];
class _SettingSecurityState extends State<SettingSecurity> {
  String currentPostOption = optionts[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.chevron_left),onPressed: ()=>Navigator.pop(context),),
        title: Text("Setting", style: GoogleFonts.ubuntu(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
      body: Container(
        width: THelperFunction.screenWidth(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  children: [
                    Text("Post setting", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                    DropdownButtonFormField(
                     decoration: const InputDecoration(
                            labelText: "Setting Type",
                          ),
                    items:optionts.map((option)=> DropdownMenuItem(value: option,child: Text(option),)).toList(), 
                    value: currentPostOption,
                    onChanged: (value){
                      setState(() {
                        currentPostOption = value.toString();
                      });
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              child: Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  children: [
                    Text("Email setting", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                    DropdownButtonFormField(
                       decoration: const InputDecoration(
                              labelText: "Setting Type",
                            ),
                      items:optionts.map((option)=> DropdownMenuItem(value: option,child: Text(option),)).toList(), 
                      value: currentPostOption,
                      onChanged: (value){
                        setState(() {
                          currentPostOption = value.toString();
                        });
                      }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              child: Padding(
                padding:const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  children: [
                    Text("Birthday setting", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                     DropdownButtonFormField(
                       decoration: const InputDecoration(
                              labelText: "Setting Type",
                            ),
                      items:optionts.map((option)=> DropdownMenuItem(value: option,child: Text(option),)).toList(), 
                      value: currentPostOption,
                      onChanged: (value){
                        setState(() {
                          currentPostOption = value.toString();
                        });
                      }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  children: [
                    Text("Phone number setting", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                    DropdownButtonFormField(
                         decoration: const InputDecoration(
                                labelText: "Setting Type",
                              ),
                        items:optionts.map((option)=> DropdownMenuItem(value: option,child: Text(option),)).toList(), 
                        value: currentPostOption,
                        onChanged: (value){
                          setState(() {
                            currentPostOption = value.toString();
                          });
                        }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  children: [
                    Text("Birthday setting", style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),),
                    DropdownButtonFormField(
                           decoration: const InputDecoration(
                                  labelText: "Setting Type",
                                ),
                          items:optionts.map((option)=> DropdownMenuItem(value: option,child: Text(option),)).toList(), 
                          value: currentPostOption,
                          onChanged: (value){
                            setState(() {
                              currentPostOption = value.toString();
                            });
                          }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: (){},
              style: ButtonStyle(
                
                foregroundColor:  WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor:  WidgetStateProperty.all<Color>(Colors.redAccent),
              ), 
              child: Text("Deactive Account", style: GoogleFonts.ubuntu(fontSize: 26)))
            ]
          ),
        ),
      )
    );
  }
}