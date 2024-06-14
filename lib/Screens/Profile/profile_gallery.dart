import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileGallery extends StatelessWidget {
  const ProfileGallery({super.key});

  @override
  Widget build(BuildContext context) {
    Profile? profile = Provider.of<UserProvider>(context).profile;
    if(profile ==null || profile.galleries!.isEmpty){
      return SliverToBoxAdapter(child: Center(
        heightFactor: 4.0,
        child: Text("No media found",style: Theme.of(context).textTheme.headlineMedium,),
      ));
    }
    return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(image: NetworkImage(profile.galleries![index].media),fit: BoxFit.cover)
                    )                
              ),
              childCount: profile.galleries!.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
            )
            );
  }
}