import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileAbout extends StatefulWidget {
  const ProfileAbout({super.key});

  @override
  State<ProfileAbout> createState() => _ProfileAboutState();
}

class _ProfileAboutState extends State<ProfileAbout> {
  @override
  Widget build(BuildContext context) {
    Profile? profile = Provider.of<UserProvider>(context).profile;
    if(profile ==null || profile.posts!.isEmpty){
      return const Text("There are no post in user profile");
    }
    return SliverToBoxAdapter(
            child:  Card(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Table(
                children: <TableRow>[
                  TableRow(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child:  Text("Full Name", style: Theme.of(context).textTheme.bodyLarge,)),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(profile.fullname, style: Theme.of(context).textTheme.bodyLarge))
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(
                         padding: const EdgeInsets.all(8.0),
                         child: Text("Email", style: Theme.of(context).textTheme.bodyLarge,)),
                      Container( 
                        padding: const EdgeInsets.all(8.0),
                        child: Text(profile.email, style: Theme.of(context).textTheme.bodyLarge,))
                    ]
                  ),
                  TableRow(
                    children: [
                       Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Phone number", style: Theme.of(context).textTheme.bodyLarge)),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(profile.phone, style: Theme.of(context).textTheme.bodyLarge))
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Gender", style: Theme.of(context).textTheme.bodyLarge)),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(profile.gender, style: Theme.of(context).textTheme.bodyLarge))
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Birthday: ", style: Theme.of(context).textTheme.bodyLarge)),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(profile.birthday!=null? DateFormat.yMMMd('en_US').format(profile.birthday!):'', style: Theme.of(context).textTheme.bodyLarge))
                    ]
                  ),
                  TableRow(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Active at: ", style: Theme.of(context).textTheme.bodyLarge)),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(DateFormat.yMMMMd('en_US').format(profile.activeAt!), style: Theme.of(context).textTheme.bodyLarge))
                    ]
                  ),
                ],
              ),
            ) 
          );
  }
}