import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).fetchProfile();
    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Profile? profile = Provider.of<UserProvider>(context).profile;
    bool isLoading = Provider.of<UserProvider>(context).isLoading;
    if(isLoading || profile==null){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      body: Container(
        child: Stack(
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
                child: Image.asset("assets/avatar/jade.png",fit: BoxFit.cover,),
                ),
            ),
            Positioned(
              top: 120, 
              left: 20,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black,width: 2.0),
                  borderRadius: BorderRadius.circular(45.0)
                ),
                width: 90,
                height: 90,
                child: CircleAvatar(
                  backgroundColor:  Colors.white,
                  child: Image.asset("assets/avatar/fuxuan.png",height: 75, width: 75,fit: BoxFit.fill,),
                ),
              ),
            ),
            Container(
              width: size.width,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(
                    height: 180,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            height: 70,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(profile.fullname, style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold)),
                                Text("@${profile.username}", style: Theme.of(context).textTheme.labelMedium,)
                              ],
                            ),
                          )
                        ],
                      ),
                      OutlinedButton(
                          onPressed: (){},
                          child: const Text("Account Setting", style: TextStyle(color: TColors.buttonPrimary),),
                        ),
                    ],
                  )
                ],
              ),
            )
          ]
        ),
      ),
    );
  }
}