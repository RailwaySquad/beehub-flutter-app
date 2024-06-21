import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<UserProvider>(context, listen: false).fetchFriends();
      Provider.of<UserProvider>(context, listen: false).fetchGroups();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Chats",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          const Text('Friends'),
          Consumer<UserProvider>(
            builder: (context, value, child) {
              return Container(
                height: 85,
                margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var user = value.friends[index];
                    return Container(
                      width: 65,
                      margin: const EdgeInsets.only(right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ClipOval(
                              child: Image.asset(user.image != null
                                  ? user.image!
                                  : user.gender == "male"
                                      ? "assets/avatar/user_male.png"
                                      : "assets/avatar/user_female.png")),
                          Text(
                            user.username,
                            style: const TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(123, 123, 123, 1)),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: value.friends.length,
                  scrollDirection: Axis.horizontal,
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          const Text('Groups'),
          Consumer<UserProvider>(
            builder: (context, value, child) {
              return Container(
                height: 85,
                margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var group = value.groups[index];
                    return Container(
                      width: 65,
                      margin: const EdgeInsets.only(right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ClipOval(
                              child: Image.asset(
                                  group.imageGroup != null ? group.imageGroup! : "assets/avatar/group_image.png")),
                          Text(
                            value.groups[index].groupname,
                            style: const TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(123, 123, 123, 1)),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: value.groups.length,
                  scrollDirection: Axis.horizontal,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
