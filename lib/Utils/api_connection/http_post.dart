import 'dart:convert';
import 'dart:io';
import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Models/comment.dart';
import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Models/postMe.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:http/http.dart' as http;
class ApiService  {
  static final String BaseUrl= AppUrl.api;
  static Future<Post> getPostById(int id) async{
    try{
      DatabaseProvider db = DatabaseProvider();
    String token = await db.getToken(); 
      http.Response response = await http.get(Uri.parse('$BaseUrl/posts/$id'),
       headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
       });
      print(response.body);
      
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
  static Future<List<Comment>> getComment(int id) async{
    try{
      DatabaseProvider db = DatabaseProvider();
      String token = await db.getToken(); 
      http.Response response = await http.get(Uri.parse('$BaseUrl/posts/comment/$id'),
       headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
       });
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
  static Future<PostMe> createPost(PostMe post,{File? media}) async {
    try {
       DatabaseProvider db = DatabaseProvider();
    String token = await db.getToken();
      // http.Response response = await http.post(
      //   Uri.parse('$BaseUrl/posts/create'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     'Authorization': 'Bearer $token'
      //   },
      //   body: json.encode(post.toJson()),
      // );
      // print(post.id);
      http.MultipartRequest req = http.MultipartRequest('POST', Uri.parse('$BaseUrl/posts/create'))
        ..fields['text'] = post.text
        ..fields['color'] = post.color!
        ..fields['background'] = post.background!
        ..fields['media'] = post.media == null ? '' : post.media!
        ..fields['user'] = post.user.toString();
      req.headers.addAll({'Authorization': 'Bearer $token'});
      http.StreamedResponse response = await req.send();

      print(response.statusCode);
      if (response.statusCode == 200) {
        return post;
      } else {
        print('Failed to create post: ${response.statusCode}');
        throw Exception('Failed to create post');
      }
    } catch (e) {
      print('Error creating post: $e');
      throw Exception('Failed to create post');
    }
  }
}