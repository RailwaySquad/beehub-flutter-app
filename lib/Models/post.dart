import 'dart:core';

class Post {
  final int id;
  final String text;
  final int userId;
  final String userFullname;
  final String userUsername;
  final String? userImage;
  final String userGender;
  final int? groupId;
  final String? groupName;
  final bool? publicGroup;
  final String? groupImage;
  final String settingType;
  final String? color;
  final String? background;
  final String? medias;
  final DateTime? createdAt;

  Post({ required this.id, required this.text, required this.userId,required this.userFullname, required this.userUsername, this.userImage, required this.userGender, this.groupId, required this.groupName, required this.publicGroup, this.groupImage, required this.settingType, this.color, this.background,this.medias,this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      'id': id,  
      'text': text,
      'user_fullname': userFullname,
      'user_username': userUsername,
      'user_image' : userImage,
      'user_gender':userGender,
      'group_id': groupId,
      'group_name':groupName,
      'public_group': publicGroup,
      'group_image': groupImage,
      'setting_type': settingType,
      'color':color,
      'background':background,
      'medias': medias,
      'createdAt':createdAt?.toIso8601String()
    };
  } 
  factory Post.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final text = json['text'] ?? '';
    final fullname = json['user_fullname'] ??'';
    final userName = json['user_username'] ??'';
    final userId = json["user_id"] ?? json["user"];
    final userimage = json['user_image'];
    final userGender = json['user_gender'] ?? '';
    final groupId = json["group_id"];
    final groupName = json['group_name'];
    final public = json['public_group'] ==1 ? true:false;
    final groupImage = json['group_image'] ;
    final settingType = json['setting_type'] ?? '';
    final color= json['color'] ?? '';
    final background= json['background'] ?? '' ;
    final medias =json["medias"] ?? json["mediaUrl"];
    final createAt = json['create_at'] !=null ? DateTime.parse(json['create_at']):null;
    return Post(
          id:id,
          text:text,
          userId: userId,
          userFullname: fullname,
          userUsername:userName,
          userImage: userimage,
          userGender: userGender,
          groupId: groupId,
          groupImage: groupImage,
          groupName: groupName,
          publicGroup: public,
          settingType: settingType,
          color: color,
          background: background,
          medias: medias,
          createdAt: createAt,
          );
  }
}