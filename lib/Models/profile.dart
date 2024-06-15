import 'package:beehub_flutter_app/Models/gallery.dart';
import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/user.dart';
import 'package:beehub_flutter_app/Models/user_setting.dart';

class Profile {
  final num id;
  final String username;
  final String email;
  final String fullname;
  final String gender;
  final String? image;
  final String? background;
  final String? bio;
  final DateTime? birthday;
  final bool isActive;
  final String? relationshipWithUser;
  final DateTime? activeAt;
  final bool isBanned;
  final String phone;
  final List<Group>? groupJoined;
  final List<Gallery>? galleries;
  final List<UserSetting>? userSettings;
  final List<User>? relationships;
  final DateTime? createdAt;
  Map<String, dynamic> toJson() {
    return {
      'id': id,  
      'username': username,
      'email': email,
      'fullname': fullname,
      'gender' : gender,
      'image':image,
      'background':background,
      'bio': bio,
      'birthday': birthday,
      'is_active': isActive,
      'relationship_with_user':relationshipWithUser,
      'active_at':activeAt,
      'is_banned': isBanned,
      'phone': phone
    };
  } 
  factory Profile.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ;
    final username = json['username'] ?? '';
    final email = json['email'] ??'';
    final fullname = json['fullname'] ??'';
    final gender = json['gender']??"";
    final image = json['image']??"";
    final background = json['background']??"";
    final bio = json['bio']??"";
    final birthday = json['birthday'] !=null? DateTime.parse(json['birthday'] ):null;
    final isActive = json['_active'] as bool ;
    final relationshipWithUser= json['relationship_with_user'] ??'';
    final activeAt= json['active_at']!=null? DateTime.parse(json['active_at']):null;
    final createdAt = json['createdAt']!=null?DateTime.parse(json['createdAt']):null;
    final isBanned = json['_banned'] as bool;
    final phone = json['phone'] ??"";
    final List<Group> groups = json['group_joined']!=null? List.from(json['group_joined'].map((e) => Group.fromJson(e))):[];
    final List<UserSetting> userSetting = json['user_settings']!=null?List.from(json['user_settings'].map((e)=> UserSetting.fromJson(e))):[];
    final List<User> relationships = json['relationships']!=null? List.from(json['relationships'].map((e)=> User.fromJson(e))):[];
    final List<Gallery> galliries = json["galleries"]!=null? List.from(json["galleries"].map((e)=> Gallery.fromJson(e))):[]; 
    return Profile(
          id:id,
          username:username, 
          fullname: fullname,
          email: email,
          phone: phone,
          gender: gender,
          image: image,
          bio: bio,
          birthday: birthday,
          isActive: isActive,
          relationshipWithUser: relationshipWithUser,
          activeAt: activeAt,
          background: background,
          isBanned: isBanned,
          groupJoined:  groups,
          galleries: galliries,
          relationships: relationships,
          userSettings: userSetting,
          createdAt: createdAt
          );
  }

  Profile({required this.id, required this.username, required this.email, required this.fullname, required this.gender, this.image, this.background, this.bio, required this.birthday, required this.isActive, this.relationshipWithUser, required this.activeAt, required this.isBanned, required this.phone, this.groupJoined, this.galleries,  this.userSettings, this.relationships, this.createdAt});
}