
import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/user.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
  List<User> _friends = [];
  bool isLoading = false;
  List<Group> _groups = [];
  List<User> get friends {
    return _friends;
  }
  Future fetchFriends()async{
    isLoading = true;
    notifyListeners();
    List<User> fetchUser= await THttpHelper.getListFriend();
    _friends = fetchUser;
    isLoading=false;
    notifyListeners();
  }
  List<Group> get groups {
    return _groups;
  }
  Future fetchGroups() async{
    isLoading = true;
    notifyListeners();
    List<Group> listGr = await THttpHelper.getGroups();
    _groups = listGr;
    isLoading = false;
    notifyListeners();
  }
}