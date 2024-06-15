import 'dart:convert';
import 'dart:io';
import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Models/comment.dart';
import 'package:beehub_flutter_app/Models/like.dart';
import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Models/postMe.dart';
import 'package:beehub_flutter_app/Models/user.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:http/http.dart' as http;
class ApiService  {
  static final String BaseUrl= AppUrl.api;
  static Future<User> getUserById(int id) async{
    try{
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken(); 
      http.Response response = await http.get(Uri.parse('$BaseUrl/user/$id'),
       headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
       });
      print(response.body);
      if(response.statusCode == 200){
        Map<String, dynamic> body = json.decode(response.body);
        User user = User.fromJson(body);
        return user;
      }
      else{
        print('Failed to load user: ${response.statusCode}');
        throw Exception('Failed to load user');
      }
    }catch(e){
      print('Error getUser by id: $e');
      throw Exception('Failed to load user');
    }
  }
  static Future<Post> getPostById(int id) async{
    try{
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken(); 
      http.Response response = await http.get(Uri.parse('$BaseUrl/posts/$id'),
       headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
       });
      if(response.statusCode == 200){
        Map<String, dynamic> body = json.decode(response.body);
        Post post = Post.fromJson(body);
        return post;
      }
      else{
        print('Failed to load post: ${response.statusCode}');
        throw Exception('Failed to load post');
      }
    }catch(e){
      print('Error getPost by id: $e');
      throw Exception('Failed to load post');
    }
  }
  static Future<int> countComment(int postId) async{
    try{
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken(); 
      http.Response response = await http.get(Uri.parse('$BaseUrl/posts/comment/post/$postId'),
       headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
       });      
      if(response.statusCode == 200){
        int count = json.decode(response.body);
        return count;
      }
      else{
        print('Failed to count comment: ${response.statusCode}');
        throw Exception('Failed to count comment');
      }
    }catch(e){
      print('Error getPost by id: $e');
      throw Exception('Failed to count comment');
    }
  }
  static Future<Comment> getCommentById(int id) async{
    try{
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken(); 
      http.Response response = await http.get(Uri.parse('$BaseUrl/posts/commentpost/$id'),
       headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
       });
      print(response.body);
      
      if(response.statusCode == 200){
        Map<String, dynamic> body = json.decode(response.body);
        Comment comment = Comment.fromJson(body);
        return comment;
      }
      else{
        print('Failed to load comment: ${response.statusCode}');
        throw Exception('Failed to load comment');
      }
    }catch(e){
      print('Error getComment by id: $e');
      throw Exception('Failed to load comment');
    }
  }
  static Future<List<Comment>> getComment(int id) async{
    try{
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken(); 
      http.Response response = await http.get(Uri.parse('$BaseUrl/posts/comment/$id'),
       headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
       });
       print('commet$response.body');
      if(response.statusCode == 200){
        List<dynamic> body = json.decode(response.body);
        List<Comment> comment = body.map((dynamic item) => Comment.fromJson(item)).toList();
        return comment;
      }
      else{
        print('Failed to load post: ${response.statusCode}');
        throw Exception('Failed to load post');
      }
    }catch(e){
      print('Error getPost by id: $e');
      throw Exception('Failed to load post');
    }
  }
    static Future<Comment> createComment(Comment comment) async {
    try {
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken();
      http.Response response = await http.post(
        Uri.parse('$BaseUrl/posts/comment/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(comment.toJson()),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        Comment newComment = Comment.fromJson(body);
        return newComment;
      } else {
        print('Failed to create comment: ${response.statusCode}');
        throw Exception('Failed to create comment');
      }
    } catch (e) {
      print('Error creating comment: $e');
      throw Exception('Failed to create comment');
    }
  }
    static Future<Comment> editComment(Comment comment) async {
    try {
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken();
      http.Response response = await http.post(
        Uri.parse('$BaseUrl/posts/comment/edit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(comment.toJson()),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        Comment newComment = Comment.fromJson(body);
        return newComment;
      } else {
        print('Failed to edit comment: ${response.statusCode}');
        throw Exception('Failed to edit comment');
      }
    } catch (e) {
      print('Error edit comment: $e');
      throw Exception('Failed to edit comment');
    }
  }
  static Future<bool> deleteComment(int id) async{
    try{
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken();
      http.Response response = await http.post(Uri.parse('$BaseUrl/posts/comment/delete/$id'),
      headers:{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      if(response.statusCode == 200){
        return true;
      }else{
        print('Failed to delete comment: ${response.statusCode}');
        throw Exception('Failed to delete comment');
      }
    }catch(e){
      print('Error delete comment: $e');
      throw Exception('Failed to delete comment');
    }
  }
  static Future<bool> deletePost(int id) async{
    try{
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken();
      http.Response response = await http.post(Uri.parse('$BaseUrl/posts/deletepost/$id'),
      headers:{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      if(response.statusCode == 200){
        return true;
      }else{
        print('Failed to delete post: ${response.statusCode}');
        throw Exception('Failed to delete post');
      }
    }catch(e){
      print('Error delete Post: $e');
      throw Exception('Failed to delete post');
    }
  }
  static Future<PostMe> createPost(PostMe post, {File? file}) async {
    try {
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken();
      var request = http.MultipartRequest('POST', Uri.parse('$BaseUrl/posts/create'))
        ..fields['text'] = post.text
        ..fields['color'] = post.color!
        ..fields['background'] = post.background!
        ..fields['user'] = post.user.toString();
      if (file != null) {
        try {
          var mediaFile = await http.MultipartFile.fromPath('medias', file.path);
          request.files.add(mediaFile);
        } catch (e) {
          print('Error adding media file: $e');
        }
      }
      request.headers.addAll({'Authorization': 'Bearer $token'});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('Response Data: $responseData');
        return post;
      } else {
        print('Failed to create post: ${response.statusCode}');
        print('Response: ${await response.stream.bytesToString()}');
        throw Exception('Failed to create post');
      }
    } catch (e) {
      print('Error creating post: $e');
      throw Exception('Failed to create post');
    }
  }
  static Future<PostMe> editPost(PostMe post, {File? file}) async {
    try {
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken();
      var request = http.MultipartRequest('POST', Uri.parse('$BaseUrl/posts/updatepost'))
        ..fields['id'] = post.id.toString()
        ..fields['text'] = post.text
        ..fields['color'] = post.color!
        ..fields['background'] = post.background!
        ..fields['user'] = post.user.toString()
        ..fields['group'] = post.group.toString();
      if (file != null) {
        try {
          var mediaFile = await http.MultipartFile.fromPath('medias', file.path);
          request.files.add(mediaFile);
        } catch (e) {
          print('Error adding media file: $e');
        }
      }
      print('Request Data: ${request.fields}');
      request.headers.addAll({'Authorization': 'Bearer $token'});
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        print('Response Data: $responseData');
        return post;
      } else {
        print('Failed to edit post: ${response.statusCode}');
        print('Response: ${await response.stream.bytesToString()}');
        throw Exception('Failed to edit post');
      }
    } catch (e) {
      print('Error edit post: $e');
      throw Exception('Failed to edit post');
    }
  }
  static Future<Like> addLike(Like like) async {
    try {
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken();
      http.Response response = await http.post(
        Uri.parse('$BaseUrl/posts/like/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(like.toJson()),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> body = json.decode(response.body);
        Like addlike = Like.fromJson(body);
        return addlike;
      } else {
        print('Failed to add Like: ${response.statusCode}');
        throw Exception('Failed to add Like');
      }
    } catch (e) {
      print('Error add Like: $e');
      throw Exception('Failed to add Like');
    }
  }
  static Future<bool> removeLike(int userid,int postid) async{
    try{
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken();
      http.Response response = await http.post(
        Uri.parse('$BaseUrl/posts/like/remove/$userid/$postid'),
        headers:{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
      if (response.statusCode == 200) {
        return true;
      }else{
        print('Failed to remove Like: ${response.statusCode}');
        throw Exception('Failed to remove Like');
      }
    }catch(e){
      print('Error remove Like: $e');
      throw Exception('Failed to remove Like');
    }
  }
  static Future<int> countLike(int postId) async{
    try{
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken(); 
      http.Response response = await http.get(Uri.parse('$BaseUrl/posts/like/user/$postId'),
       headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
       });      
      if(response.statusCode == 200){
        int count = json.decode(response.body);
        return count;
      }
      else{
        print('Failed to count comment: ${response.statusCode}');
        throw Exception('Failed to count comment');
      }
    }catch(e){
      print('Error getPost by id: $e');
      throw Exception('Failed to count comment');
    }
  }
  static Future<bool> checkLike(int userid,int postid) async{
    try{
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken();
      http.Response response = await http.get(
        Uri.parse('$BaseUrl/posts/check/$userid/$postid'),
        headers:{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
      if (response.statusCode == 200) {
        bool isLikie = json.decode(response.body);
        return isLikie;
      }else{
        print('Failed to check Like: ${response.statusCode}');
        throw Exception('Failed to check Like');
      }
    }catch(e){
      print('Error check Like: $e');
      throw Exception('Failed to check Like');
    }
  }
}