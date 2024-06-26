import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Models/group_form.dart';
import 'package:beehub_flutter_app/Models/profile_form.dart';
import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Models/requirement.dart';
import 'package:beehub_flutter_app/Models/requirementForm.dart';
import 'package:beehub_flutter_app/Models/user.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:http/http.dart';
class THttpHelper {
  static final String BaseUrl= AppUrl.api;
  
  // /homepage/{id}
  static Future<List<Post>?> getPopularPosts(int page) async{
      DatabaseProvider db =  DatabaseProvider();
      int userId = await db.getUserId();
      String token = await db.getToken();
      Response response = await get(Uri.parse("$BaseUrl/homepage/$userId?limit=5&page=$page"),
      headers: {        
        HttpHeaders.authorizationHeader: 'Bearer $token'
      }
      );
     int status = response.statusCode;
     if(status == 200){
      log("Connect database successful: $status");
      String json = response.body;
      // log(json);
      List<dynamic> listPost = jsonDecode(json);
      try {
        return List.from(listPost.map((e) => Post.fromJson(e)));
      } catch (e) {
        throw Exception(e.toString());
      }
      }else{
        return null;
      }
  } 
  // /user/groups/{id}
  static Future<List<Group>?> getGroups() async{
    DatabaseProvider db =  DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    Response response = await get(Uri.parse("$BaseUrl/user/groups/$userId"),
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token'
    }
    );
    int status = response.statusCode;
    
    if(status == 200){
      String json = response.body;
      List<dynamic> listGr = jsonDecode(json);
      try {
        return List.from(listGr.map((e) => Group.fromJson(e)));
      } catch (e) {
        throw Exception(e.toString());
      }
    }else{
      return null;
    }
  }
  // /user/${id_user}/group/${id_group}/posts?limit=3&page=${page}
  static Future<List<Post>?> getGroupPosts(num id, int page )async{
    DatabaseProvider db =  DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    Response response = await get(Uri.parse("$BaseUrl/user/$userId/group/$id/posts?limit=5&page=$page"),
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token'
    }
    );
    int status = response.statusCode;
    if(status == 200){
      String json = response.body;
      List<dynamic> listPost = jsonDecode(json);
      try {
        return List.from(listPost.map((e) => Post.fromJson(e)));
      } catch (e) {
         throw Exception(e.toString());
      }
    }else{
      return null;
    }
  }
  // /friends/{id}
  static Future<List<User>?> getListFriend()async{
    DatabaseProvider db =  DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    Response response = await get(Uri.parse("$BaseUrl/friends/$userId"),
      headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token'
    }
    );
    int status = response.statusCode;
    if(status == 200){
        String json = response.body;
        List<dynamic> listFriends = jsonDecode(json);
        try {
          return List.from(listFriends.map((e) => User.fromJson(e)));
        } catch (e) {
          log(e.toString());
          throw Exception(e.toString());
        }
      }else{
        return null;
      }
   
  }  
  //  /user/get-username/{id} 
  static Future<String> getUsername ({id})async{
    try {
      DatabaseProvider db =  DatabaseProvider();
      String token = await db.getToken();
      num  idUser= id?? await db.getUserId();
      Response response = await get(Uri.parse("$BaseUrl/user/get-username/$idUser"),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $token'
        }
      );
      if(response.statusCode==200){
        return response.body;
      }
      return "";
    } catch (e) {
      throw Exception(e);
    }
  }
  // /user/{id}/profile/{username}
  static Future<Profile?> getProfile(String username) async{
    DatabaseProvider db =  DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    Response response = await get(Uri.parse("$BaseUrl/user/$userId/profile/$username"),
      headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token'
    }
    );
    int status = response.statusCode;
    if(status == 200){
      log("Connect database successful: $status");
      String json = response.body;
      dynamic profile = jsonDecode(json);
      profile["own"] =  profile["id"]!=null&& userId==profile["id"] ? true:false;
      try {
        return Profile.fromJson(profile);
      } catch (e) {
        log(e.toString());
        throw Exception(e);
      }
    }else{
      return null;
      
    }
  }
  ///user/{id_user}/get-posts/{username}
  static Future<List<Post>?> getProfilePost(String username,int page) async{
    DatabaseProvider db= DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    Response response = await get(Uri.parse("$BaseUrl/user/$userId/get-posts/$username?limit=3&page=$page"),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token'
      }
    );
    int status = response.statusCode;
    if(status == 200){
      String json = response.body;
      if(json.isEmpty){
        String us=  await getUsername();
        Response response2 = await get(Uri.parse("$BaseUrl/user/$userId/get-posts/$us?limit=3&page=$page"),
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token'
          }
        );
        json = response2.body;
      }
      dynamic post = jsonDecode(json);
      try {
        return  List.from(post.map((e) => Post.fromJson(e)));
      } catch (e) {
        log(e.toString());
        throw Exception(e);
      }
    }else{
      return null;
      
    }
  }
  // /user/request/{id} get notification
  static Future<List<Requirement>?> getNotification()async{
    DatabaseProvider db= DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    Response response = await get(Uri.parse("$BaseUrl/user/request/$userId"),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token'
      }
    );
    int status = response.statusCode;
    if(status == 200){
      String json = response.body;
      dynamic requirement= jsonDecode(json);
      try {
        return  List.from(requirement.map((e) => Requirement.fromJson(e)));
      } catch (e) {
        log(e.toString());
        throw Exception(e);
      }
    }else{
      return null;
    }
  }
  ///user/{id_user}/get-group/{id_group}
  static Future<Group?> getGroup(num idGroup) async{
    DatabaseProvider db= DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    Response response = await get(Uri.parse("$BaseUrl/user/$userId/get-group/$idGroup"),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token'
      }
    );
    int status = response.statusCode;
    if(status == 200){
      String json = response.body;
      log(json);
      dynamic group= jsonDecode(json);
      try {
        return Group.fromJson(group);
      } catch (e) {
        log(e.toString());
        throw Exception(e);
      }
    }else{
      return null;
    }
  }
  ///user/{id}/search_all
  ///List<PostDto> posts
  ///List<UserDto> people
  ///List<GroupDto> groups
  static Future<Map<String, dynamic>> getSearchResult(String search) async{
    DatabaseProvider db= DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    Response response = await get(Uri.parse("$BaseUrl/user/$userId/search_all?search=$search"),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token'
      }
    );
    int status = response.statusCode;
    Map<String ,dynamic>  result =  <String, dynamic>{};
    if(status == 200){
      String json = response.body;
      dynamic res= jsonDecode(json);
      try {
        result["posts"]= List.from(res["posts"].map((e)=> Post.fromJson(e)));
        result["groups"]=List.from(res["groups"].map((e)=> Group.fromJson(e)));
        result["people"]=List.from(res["people"].map((e)=> User.fromJson(e)));
        return result;
      } catch (e) {
        log(e.toString());
        throw Exception(e);
      }
    }else{
      return result;
    }
  }
  ///send-requirement/${id}
  static Future<Map<String,String>?> createRequirement(Requirementform data)async{
    DatabaseProvider db= DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    Response response = await post(Uri.parse("$BaseUrl/send-requirement/$userId"),
      headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: json.encode(data.toJson())
    );
     int status = response.statusCode;
     if(status == 200){
      String json = response.body;
      dynamic res= jsonDecode(json);
      try {
        return Map<String,String>.from(res);
      } catch (e) {
        log(e.toString());
        throw Exception(e);
      }
    }else{
      return null;
    }
  }
  static Future<bool> checkUsername(String username)async{
    DatabaseProvider db= DatabaseProvider();
    String token = await db.getToken();
    Response response = await get(Uri.parse("$BaseUrl/check-user?username=$username"),
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $token'
    });
     int status = response.statusCode;
     if(status==200){
      bool res = jsonDecode(response.body) as bool;
      log(res.toString());
      return res ;
     }
     log("Error Netword connect");
     return false;
  }
  static Future<bool> checkEmail(String email)async{
    DatabaseProvider db= DatabaseProvider();
    String token = await db.getToken();
    Response response = await get(Uri.parse("$BaseUrl/check-email?email=$email"),
    headers: {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'

    });
     int status = response.statusCode;
     if(status==200){
      bool res = jsonDecode(response.body) as bool;
      log(res.toString());
      return res;
     }
     log("Error Netword connect");
     return false;
  }
  ///check-password/
  static Future<bool> checkPassword(String password)async{
    DatabaseProvider db= DatabaseProvider();
    String token = await db.getToken();
    Response response = await get(Uri.parse("$BaseUrl/check-password/?password=$password"),
    headers: {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });
     int status = response.statusCode;
     log(status.toString());
     if(status==200){
      bool res = jsonDecode(response.body) as bool;
      log(res.toString());
      return res ;
     }
     log("Error Netword connect");
     return false;
  }
  ///update/profile/password/
  static Future<bool> updatePassword(String password)async{
    DatabaseProvider db= DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    Response response = await post(Uri.parse("$BaseUrl/update/profile/password/$userId"),
    headers: {
      "Content-Type": 'text/plain',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    },
    body: password
    );
    int status = response.statusCode;
    if(status==200){
      bool res = jsonDecode(response.body) as bool;
      log(res.toString());
      return res;
    }
    log("Error Netword connect");
    return false;
  }
  ///update/profile/{id}
  static Future<bool> updateProfile (Profileform data) async {
    DatabaseProvider db= DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    Response response = await post(Uri.parse("$BaseUrl/update/profile/$userId"),
    headers: {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
    body: json.encode(data.toJson())
    );
    int status = response.statusCode;
    if(status==200){
      bool res = jsonDecode(response.body) as bool;
      return res;
    }
    log("Error Netword connect");
    return false;
  }
  //UploadAvatar /upload/profile/image/{id}
  static Future<dynamic> uploadAvatar(File file)async{
    DatabaseProvider db= DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    var request =  MultipartRequest("POST",Uri.parse("$BaseUrl/upload/profile/image/$userId"));
    var myFile = await MultipartFile.fromPath("media",file.path);
    request.headers.addAll({HttpHeaders.authorizationHeader: 'Bearer $token'});
    request.files.add(myFile);
    final response = await request.send();
    if(response.statusCode==201){
      var data = await response.stream.bytesToString();
      return jsonDecode(data);
    }else{
      return null;
    }
  }
  static Future<dynamic> uploadBackground(File file)async{
    DatabaseProvider db= DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    log("Upload Background: ${file.path}");
    var request =  MultipartRequest("POST",Uri.parse("$BaseUrl/upload/profile/background/$userId"));
    var myFile = await MultipartFile.fromPath("media",file.path);
    request.headers.addAll({'Authorization': 'Bearer $token'});
    request.files.add(myFile);
    final response = await request.send();
    if(response.statusCode==201){
      var data = await response.stream.bytesToString();
      return jsonDecode(data);
    }else{
      return null;
    }
  }

  static Future<dynamic> uploadBackgroudGr(File file,int idGr)async {
    DatabaseProvider db= DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    var request =  MultipartRequest("POST",Uri.parse("$BaseUrl/upload/group/$idGr/background/$userId"));
    var myFile = await MultipartFile.fromPath("media",file.path);
    request.headers.addAll({HttpHeaders.authorizationHeader: 'Bearer $token'});
    request.files.add(myFile);
    final response = await request.send();
    if(response.statusCode==201){
      var data = await response.stream.bytesToString();
      return jsonDecode(data);
    }else{
      return null;
    }
  }

  static Future<dynamic> uploadImgGr(File file,int idGr) async {
    DatabaseProvider db= DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    var request =  MultipartRequest("POST",Uri.parse("$BaseUrl/upload/group/$idGr/image/$userId"));
    var myFile = await MultipartFile.fromPath("media",file.path);
    request.headers.addAll({HttpHeaders.authorizationHeader: 'Bearer $token'});
    request.files.add(myFile);
    final response = await request.send();
    if(response.statusCode==201){
      var data = await response.stream.bytesToString();
      return jsonDecode(data);
    }else{
      return null;
    }
  }
///update/group/
  static Future<dynamic> updateGroup(GroupForm group) async {
     DatabaseProvider db= DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    Response response = await post(Uri.parse("$BaseUrl/update/group/$userId"),
    headers: {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
    body: json.encode(group.toJson())
    );
    int status = response.statusCode;
    if(status==200){
      dynamic res = jsonDecode(response.body);
      return Map<String, bool>.from(res);
    }
    log("Error Netword connect");
    return false;
  }
  static Future<dynamic> createGroup(GroupForm group) async {
     DatabaseProvider db= DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    Response response = await post(Uri.parse("$BaseUrl/user/create-group/flutter/$userId"),
    headers: {
      'Content-Type': 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $token'
    },
    body: json.encode(group.toJson())
    );
    int status = response.statusCode;
    if(status==200){
      log(response.body);
      dynamic res = jsonDecode(response.body);
      return res;
    }
    log("Error Netword connect");
    return false;
  }
  static Future<Map<String, int>> updateSettingPost(String type)async{
    DatabaseProvider db= DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    Response response = await post(Uri.parse("$BaseUrl/update/setting/$userId"),
      headers: {
        'Content-Type': 'text/plain',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: type
    );
    int status = response.statusCode;
    if(status==200){
      log(response.body);
      dynamic res = jsonDecode(response.body);
      return Map<String,int>.from(res);
    }
    log("Error Netword connect");
    return <String,int>{"result":0};
  }
  static Future<dynamic> updateSetting(Map<String, String> data)async{
    DatabaseProvider db= DatabaseProvider();
    int userId = await db.getUserId();
    String token = await db.getToken();
    log(json.encode(data).toString());
    try {
      Response response = await post(Uri.parse("$BaseUrl/setting/add/$userId"),
        headers: {
          'Content-Type': "application/json",
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: json.encode(data)
      );
      int status = response.statusCode;
      if(status==200){
        log(response.body);
        dynamic res = jsonDecode(response.body);
        return res;
      }
      return false;
    } catch (e) {
      log("Error Netword connect");
      log(e.toString());
      return false;
      
    }
  }
}