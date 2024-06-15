import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Models/profile.dart';
import 'package:beehub_flutter_app/Models/requirement.dart';
import 'package:beehub_flutter_app/Models/requirementForm.dart';
import 'package:beehub_flutter_app/Models/user.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:http/http.dart';
class THttpHelper {
  // late final String _URL_API= "http://10.0.2.2:8089"; 
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
     log(status.toString());
     if(status == 200){
      log("Connect database successful: $status");
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
      log(json);
      dynamic res= jsonDecode(json);
      try {
        return <String,String>{};
      } catch (e) {
        log(e.toString());
        throw Exception(e);
      }
    }else{
      return null;
    }
  }
}