import 'dart:core';
class PostMe {
  final int? id;
  final String text;
  final String? color;
  final String? background;
  final String? medias;
  final int user;
  final int? group;

  PostMe({this.id, required this.text, this.color, this.background,this.medias,required this.user, this.group});

  Map<String, dynamic> toJson() {
    return {
      'id': id,  
      'text': text,
      'color':color,
      'background':background,
      'medias': medias,
      'user':user,
      'group':group
    };
  } 
  factory PostMe.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final text = json['text'] ?? '';
    final color= json['color'] ?? '';
    final background= json['background'] ?? '' ;
    final medias = json['medias']??'';
    final user = json['user'] as int;
    final group = json['group'] as int;
    return PostMe(
          id:id,
          text:text, 
          color: color,
          background: background,
          medias: medias,
          user: user,
          group:group
          );
  }
}