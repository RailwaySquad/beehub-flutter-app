
import 'dart:developer';

import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Models/user_setting.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:beehub_flutter_app/Utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingSecurity extends StatefulWidget {
  const SettingSecurity({super.key});

  @override
  State<SettingSecurity> createState() => _SettingSecurityState();
}

List<String> optionts = ["Option", "Public", "For Friend","Private"];
List<String> optiontsVal = ["", "PUBLIC", "FOR_FRIEND","HIDDEN"];
class _SettingSecurityState extends State<SettingSecurity> {
  final scrollController = ScrollController();
  
  @override
  Widget build(BuildContext context) {
    Profile? profile = Provider.of<UserProvider>(context).profile;
    if(profile==null){
      return  Scaffold(
        appBar: AppBar(title: const Text("Setting"),),
        body: const  Center(child: Text("Error"),heightFactor: 100,),
      );
    }
    List<UserSetting> settings = profile.userSettings!;
    int checkSetting(String type){
      if(settings.isNotEmpty){
        for (var element in settings) {
          log(element.settingType);
          if (element.settingItem==type &&element.settingType == "PUBLIC") {
            return 1;
          }else if(element.settingItem==type&&element.settingType == "FOR_FRIEND"){
            return 2;
          }else if(element.settingItem==type&&element.settingType == "HIDDEN"){
            return 3;
          } 
        }
      }
      return 1 ;
    }
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
              ListTile(
                onTap: (){
                  showDialog(
                    context: context, 
                    builder: (BuildContext builder){
                      int active = 0;
                      return AlertDialog(
                        title: Text("Posts Setting", style: Theme.of(context).textTheme.titleLarge,),
                        content: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState){
                            return SizedBox(
                              height: 226,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile(
                                    value: 0, groupValue: active, onChanged: (value){
                                        setState(() {
                                          active=value!;
                                        });
                                        },
                                        title: Text(optionts[0]),),
                                  RadioListTile(
                                    value: 1, groupValue: active, onChanged: (value){
                                        setState(() {
                                          active=value!;
                                        });
                                        },
                                        title: Text(optionts[1]),
                                        ),
                                  RadioListTile(
                                    value: 2, groupValue: active, onChanged: (value){
                                      setState(() {
                                        active=value!;
                                        });
                                        },
                                      title: Text(optionts[2]),),
                                  RadioListTile(
                                    value: 3, groupValue: active, onChanged: (value){
                                      setState(() {
                                        active=value!;
                                      });
                                      },
                                    title: Text(optionts[3]),)
                                ]),
                            );
                          }),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: ()async {
                                await THttpHelper.updateSettingPost(optiontsVal[active]);
                                Navigator.pop(context, 'Ok');
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Changing post status success"),
                                    ));
                              },
                              child: const Text('OK'),
                            ),
                          ],
                          );
                    }
                    );
                },
                title: Text("Post setting", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
              ),
              ListTile(
                onTap: (){
                  showDialog(
                    context: context, 
                    builder: (BuildContext builder){
                      int active = checkSetting("email");
                      return AlertDialog(
                        title: Text("Email Setting", style: Theme.of(context).textTheme.titleLarge,),
                        content: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState){
                            return SizedBox(
                              height: 170,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile(
                                    value: 1, groupValue: active, onChanged: (value){
                                        setState(() {
                                          active=value!;
                                        });
                                        },
                                        title: Text(optionts[1]),
                                        ),
                                  RadioListTile(
                                    value: 2, groupValue: active, onChanged: (value){
                                      setState(() {
                                        active=value!;
                                        });
                                        },
                                      title: Text(optionts[2]),),
                                  RadioListTile(
                                    value: 3, groupValue: active, onChanged: (value){
                                      setState(() {
                                        active=value!;
                                      });
                                      },
                                    title: Text(optionts[3]),)
                                ]),
                            );
                          }),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: ()async {
                                Map<String, String> req = {"email": optiontsVal[active]};
                                final resp = await THttpHelper.updateSetting(req);
                                if(resp==true){
                                  Provider.of<UserProvider>(context, listen: false).fetchProfile(true);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Setting success"),
                                    ));
                                }
                                Navigator.pop(context, 'Ok');
                              },
                              child: const Text('OK'),
                            ),
                          ],
                          );
                    }
                    );
                },
                title: Text("Email setting", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
              ),
              ListTile(
                onTap: (){
                  showDialog(
                    context: context, 
                    builder: (BuildContext builder){
                      int active = checkSetting("gender");
                      return AlertDialog(
                        title: Text("Setting", style: Theme.of(context).textTheme.titleLarge,),
                        content: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState){
                            return SizedBox(
                              height: 170,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile(
                                    value: 1, groupValue: active, onChanged: (value){
                                        setState(() {
                                          active=value!;
                                        });
                                        },
                                        title: Text(optionts[1]),
                                        ),
                                  RadioListTile(
                                    value: 2, groupValue: active, onChanged: (value){
                                      setState(() {
                                        active=value!;
                                        });
                                        },
                                      title: Text(optionts[2]),),
                                  RadioListTile(
                                    value: 3, groupValue: active, onChanged: (value){
                                      setState(() {
                                        active=value!;
                                      });
                                      },
                                    title: Text(optionts[3]),)
                                ]),
                            );
                          }),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: ()async {
                                Map<String, String> req = {"gender": optiontsVal[active]};
                                final resp = await THttpHelper.updateSetting(req);
                                if(resp==true){
                                  Provider.of<UserProvider>(context, listen: false).fetchProfile(true);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Setting success"),
                                    ));
                                }
                                Navigator.pop(context, 'Ok');
                              },
                              child: const Text('OK'),
                            ),
                          ],
                          );
                    }
                    );
                },
                title: Text("Gender setting", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
              ),
               ListTile(
                onTap: (){
                  showDialog(
                    context: context, 
                    builder: (BuildContext builder){
                      int active =checkSetting("birthday");
                      return AlertDialog(
                        title: Text("Bithday Setting", style: Theme.of(context).textTheme.titleLarge,),
                        content: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState){
                            return SizedBox(
                              height: 170,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile(
                                    value: 1, groupValue: active, onChanged: (value){
                                        setState(() {
                                          active=value!;
                                        });
                                        },
                                        title: Text(optionts[1]),
                                        ),
                                  RadioListTile(
                                    value: 2, groupValue: active, onChanged: (value){
                                      setState(() {
                                        active=value!;
                                        });
                                        },
                                      title: Text(optionts[2]),),
                                  RadioListTile(
                                    value: 3, groupValue: active, onChanged: (value){
                                      setState(() {
                                        active=value!;
                                      });
                                      },
                                    title: Text(optionts[3]),)
                                ]),
                            );
                          }),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: ()async {
                                Map<String, String> req = {"birthday": optiontsVal[active]};
                                final resp = await THttpHelper.updateSetting(req);
                                if(resp==true){
                                  Provider.of<UserProvider>(context, listen: false).fetchProfile(true);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Setting success"),
                                    ));
                                }
                                Navigator.pop(context, 'Ok');
                              },
                              child: const Text('OK'),
                            ),
                          ],
                          );
                    }
                    );
                },
                title: Text("Birthday setting", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
              ),
               ListTile(
                onTap: (){
                  showDialog(
                    context: context, 
                    builder: (BuildContext builder){
                      int active = checkSetting("phone");
                      return AlertDialog(
                        title: Text("Phone Setting", style: Theme.of(context).textTheme.titleLarge,),
                        content: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState){
                            return SizedBox(
                              height: 170,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile(
                                    value: 1, groupValue: active, onChanged: (value){
                                        setState(() {
                                          active=value!;
                                        });
                                        },
                                        title: Text(optionts[1]),
                                        ),
                                  RadioListTile(
                                    value: 2, groupValue: active, onChanged: (value){
                                      setState(() {
                                        active=value!;
                                        });
                                        },
                                      title: Text(optionts[2]),),
                                  RadioListTile(
                                    value: 3, groupValue: active, onChanged: (value){
                                      setState(() {
                                        active=value!;
                                      });
                                      },
                                    title: Text(optionts[3]),)
                                ]),
                            );
                          }),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: ()async {
                                Map<String, String> req = {"phone": optiontsVal[active]};
                                
                                final resp = await THttpHelper.updateSetting(req);
                                if(resp==true){
                                  Provider.of<UserProvider>(context, listen: false).fetchProfile(true);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Setting success"),
                                    ));
                                }
                                Navigator.pop(context, 'Ok');
                              },
                              child: const Text('OK'),
                            ),
                          ],
                          );
                    }
                    );
                },
                title: Text("Phone number setting", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
              ),
               ListTile(
                onTap: (){
                  showDialog(
                    context: context, 
                    builder: (BuildContext builder){
                      int active = checkSetting("list_friend");
                      return AlertDialog(
                        title: Text("List Friend Setting", style: Theme.of(context).textTheme.titleLarge,),
                        content: StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState){
                            return SizedBox(
                              height: 170,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RadioListTile(
                                    value: 1, groupValue: active, onChanged: (value){
                                        setState(() {
                                          active=value!;
                                        });
                                        },
                                        title: Text(optionts[1]),
                                        ),
                                  RadioListTile(
                                    value: 2, groupValue: active, onChanged: (value){
                                      setState(() {
                                        active=value!;
                                        });
                                        },
                                      title: Text(optionts[2]),),
                                  RadioListTile(
                                    value: 3, groupValue: active, onChanged: (value){
                                      setState(() {
                                        active=value!;
                                      });
                                      },
                                    title: Text(optionts[3]),)
                                ]),
                            );
                          }),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: ()async {
                                Map<String, String> req = {"list_friend": optiontsVal[active]};
                                final resp = await THttpHelper.updateSetting(req);
                                if(resp==true){
                                  Provider.of<UserProvider>(context, listen: false).fetchProfile(true);
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Setting success"),
                                    ));
                                }
                                Navigator.pop(context, 'Ok');
                              },
                              child: const Text('OK'),
                            ),
                          ],
                          );
                    }
                    );
                },
                title: Text("List Friend setting", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),),
              ),
            const SizedBox(height: 15),
            // ElevatedButton(
            //   onPressed: (){},
            //   style: ButtonStyle(
                
            //     foregroundColor:  WidgetStateProperty.all<Color>(Colors.white),
            //     backgroundColor:  WidgetStateProperty.all<Color>(Colors.redAccent),
            //   ), 
            //   child: Text("Deactive Account", style: GoogleFonts.ubuntu(fontSize: 26)))
            ]
          ),
        ),
      )
    );
  }
}