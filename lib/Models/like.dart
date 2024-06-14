import 'dart:core';
class Like {
  final int? id;
  final String enumEmo;
  final int user;
  final int post;
  Like({this.id, required this.enumEmo,required this.user,required this.post});

  Map<String, dynamic> toJson() {
    return {
      'id': id,  
      'enumEmo': enumEmo,
      'user':user,
      'post':post
    };
  } 
  factory Like.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final enumEmo = json['enumEmo'] ?? '';
    final user = json['user'] as int;
    final post = json['post'] as int;
    return Like(
          id:id,
          enumEmo:enumEmo, 
          user: user,
          post:post
          );
  }
}