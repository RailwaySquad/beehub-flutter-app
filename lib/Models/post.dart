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
  final bool? share;
  final String? usershareUserName;
  final String? usershareFullname;
  final String? usershareGender;
  final String? usershareImage;
  final String? usershareGroupName;
  final num? usershareGroupId;
  final DateTime? usershareCreatedAt;
  final DateTime? createdAt;

  Post({ required this.id, required this.text, required this.userId,required this.userFullname, required this.userUsername, this.userImage, required this.userGender, this.groupId, required this.groupName, required this.publicGroup, this.groupImage, required this.settingType, this.color, this.background,this.medias,this.share, this.usershareFullname, this.usershareGender, this.usershareImage,this.usershareUserName,this.usershareGroupName,this.usershareGroupId, this.usershareCreatedAt,this.createdAt});

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
      'share':share,
      'usershare_fullname':usershareFullname,
      'usershare_gender':usershareGender,
      'usershareimage':usershareImage,
      'usershare_username':usershareUserName,
      'usershareGroupName':usershareGroupName,
      'usershareGroupId':usershareGroupId,
      'timeshare':usershareCreatedAt?.toIso8601String(),
      'create_at':createdAt?.toIso8601String()
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
    final share = json['share'] ?? false;
    final usershareFullname= json['usershare_fullname'] ?? '' ;
    final usershareGender= json['usershare_gender'] ?? '' ;
    final usershareImage= json['usershareimage'] ?? '' ;
    final usershareUserName= json['usershare_username'] ?? '' ;
    final usershareGroupName= json['usershareGroupName'] ?? '' ;
    final usershareGroupId= json['usershareGroupId'] ;
    final usershareCreatedAt = json['timeshare'] !=null ? DateTime.parse(json['timeshare']):null;
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
          share:share,
          usershareFullname:usershareFullname,
          usershareGender:usershareGender,
          usershareImage:usershareImage,
          usershareUserName:usershareUserName,
          usershareGroupName:usershareGroupName,
          usershareGroupId:usershareGroupId,
          usershareCreatedAt:usershareCreatedAt,
          createdAt: createAt,
          );
  }
}