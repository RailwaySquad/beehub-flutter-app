import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ProfileSettingPage extends StatefulWidget {
  const ProfileSettingPage({super.key});

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).fetchProfile(true);
    }); 
  }
  @override
  Widget build(BuildContext context) {
    Profile? profile = Provider.of<UserProvider>(context, listen: false).profile;
    var size = MediaQuery.of(context).size;
    bool isLoading = Provider.of<UserProvider>(context).isLoading;
    if(isLoading || profile==null){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Get.toNamed("/");},icon: const Icon(Icons.chevron_left),),
        title: const Text("Profile Setting"),
        actions: [
          TextButton(onPressed: (){}, child: const Text("Save"))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                          border:  Border(bottom: BorderSide(color: TColors.secondary,width: 2.0))
                        ),
                      height: 180,
                      width: size.width,
                      child: Container(
                        color:TColors.darkerGrey,
                        child: profile.background!.isNotEmpty? Image.network(profile.background!): const SizedBox(),
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
                        child: GestureDetector(child: profile.image!.isNotEmpty? Image.network(profile.image!,height: 75, width: 75,fit: BoxFit.fill):
                          (profile.gender == 'female'?
                          Image.asset("assets/avatar/user_female.png",height: 75, width: 75,fit: BoxFit.fill):Image.asset("assets/avatar/user_male.png",height: 75, width: 75,fit: BoxFit.fill)
                          ),)
                      ),
                    ),
                  ]
                ),
            const SizedBox(height: 50,),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                
                child: Column(
                  children: [
                    TextField(
                            decoration: InputDecoration(
                              label: const Text("Full name"),
                            ),
                            
                          )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}