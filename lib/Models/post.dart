import 'dart:core';
class Post {
  final int id;
  final String text;
  final String userFullname;
  final String userUsername;
  final String? userImage;
  final String userGender;
  final String? groupName;
  final bool publicGroup;
  final String? groupImage;
  final String settingType;
  final String? color;
  final String? background;
  final String? media;

  Post({ required this.id, required this.text, required this.userFullname, required this.userUsername, this.userImage, required this.userGender, required this.groupName, required this.publicGroup, this.groupImage, required this.settingType, this.color, this.background,this.media});

  Map<String, dynamic> toJson() {
    return {
      'id': id,  
      'text': text,
      'user_fullname': userFullname,
      'user_username': userUsername,
      'user_image' : userImage,
      'user_gender':userGender,
      'group_name':groupName,
      'public_group': publicGroup,
      'group_image': groupImage,
      'setting_type': settingType,
      'color':color,
      'background':background,
      'media': media,
    };
  } 
  factory Post.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final text = json['text'] ?? '';
    final fullname = json['user_fullname'] ??'';
    final userName = json['user_username'] ??'';
    final userimage = json['user_image'];
    final userGender = json['user_gender'] ?? '';
    final groupName = json['group_name'];
    final public = json['public_group'] ==1 ? true:false;
    final groupImage = json['group_image'] ;
    final settingType = json['setting_type'] ?? '';
    final color= json['color'] ?? '';
    final background= json['background'] ?? '' ;
    final media = json['medias']??'';
    return Post(
          id:id,
          text:text, 
          userFullname: fullname,
          userUsername:userName,
          userImage: userimage,
          userGender: userGender,
          groupImage: groupImage,
          groupName: groupName,
          publicGroup: public,
          settingType: settingType,
          color: color,
          background: background,
          media: media,
          );
  }
}