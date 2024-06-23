import 'package:flutter/material.dart';
import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:provider/provider.dart';
class GroupMedia extends StatelessWidget {
  const GroupMedia({super.key});

  @override
  Widget build(BuildContext context) {
     Group? group = Provider.of<UserProvider>(context).group;

    if(group==null ){
      return const SliverToBoxAdapter (
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(
            TColors.buttonPrimary
          ),
        ),
      );
    }
    if(group.groupMedias!.isEmpty){
      return SliverToBoxAdapter(child: Center(
        heightFactor: 4.0,
        child: Text("Not  Found Media",style: Theme.of(context).textTheme.headlineMedium,),
      ));
    }
    return SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(image: NetworkImage(group.groupMedias![index].media),fit: BoxFit.cover)
                    )                
              ),
              childCount: group.groupMedias!.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
            )
            );
  }
}