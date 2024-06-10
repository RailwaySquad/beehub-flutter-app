import 'dart:core';
class PostMe {
  final int? id;
  final String text;
  final String? color;
  final String? background;
  final String? media;
  final int user;

  PostMe({this.id, required this.text, this.color, this.background,this.media,required this.user});

  Map<String, dynamic> toJson() {
    return {
      'id': id,  
      'text': text,
      'color':color,
      'background':background,
      'media': media,
      'user':user
    };
  } 
  factory PostMe.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final text = json['text'] ?? '';
    final color= json['color'] ?? '';
    final background= json['background'] ?? '' ;
    final media = json['media']??'';
    final user = json['user'] as int;
    return PostMe(
          id:id,
          text:text, 
          color: color,
          background: background,
          media: media,
          user: user
          );
  }
}