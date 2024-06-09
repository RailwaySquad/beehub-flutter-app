import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Container(
                color:Colors.blueAccent,
                ),
            ),
            Expanded(
              child: Column(children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Image.asset("assets/avatar/fuxuan.png"),
                    ),
                    
                  ],
                )
              ],))
          ],
        ),
      ),
    );
  }
}