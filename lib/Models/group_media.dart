import 'dart:developer';

class GroupMedia{
  final int? id;
  final String media;
  final String mediaType;
  final DateTime? createAt;
  final String? username;
  final String? fullname;
  final int? groupId;
  final int? postId;

  GroupMedia({ this.id, required this.media, required this.mediaType,  this.createAt, this.username,  this.fullname,  this.groupId, this.postId});
  factory GroupMedia.fromJson(Map<String, dynamic> json){
    final id = json["id"];
    final media = json["media"];
    final mediaType = json["media_type"];
    final createAt = json["create_at"]!=null? DateTime.parse(json["create_at"]):null;
    final username = json["username"]??'';
    final fullname = json["fullname"]??'';
    final groupId = json["group_id"];
    final postId = json["post_id"];
    log("id: $id\tmedia: $media\tmediaT: $mediaType\tcreate: $createAt\tusername: $username\tfullname: $fullname\tgroupId: $groupId\tPostId: $postId");
    return GroupMedia(
      id: id, 
      media: media, 
      mediaType: mediaType, 
      createAt: createAt, 
      username: username, 
      fullname: fullname, 
      groupId: groupId, 
      postId: postId);
  }
}