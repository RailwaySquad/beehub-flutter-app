class GroupMember{
  final int? id;
  final int userId;
  final String username;
  final String? userImage;
  final String? userGender;
  final String? userFullname;
  final int groupId;
  final String? groupName;
  final String? groupImage;
  final bool joined;
  final String? role;
  final String? relationship;

  GroupMember({this.id, required this.userId, required this.username, this.userImage, required this.userGender, required this.userFullname, required this.groupId, this.groupName, this.groupImage, required this.joined, this.role, this.relationship});

  factory GroupMember.fromJson(Map<String, dynamic> json){
    final int id = json["id"];
    final int userId = json["user_id"];
    final String username = json["username"];
    final String userImg = json["user_image"]??'';
    final String userFullname = json['user_fullname']??'';
    final String userGender = json["user_gender"]??'';
    final int groupId = json["group_id"];
    final String groupName = json["group_name"]??'';
    final String groupImage = json["group_image"]??'';
    final bool joined = json["joined"];
    final String role = json["role"]??'';
    final String relationship = json["relationship"]??'';
    return GroupMember(
      id: id,
      userId: userId, 
      username: username, 
      userGender: userGender, 
      userImage: userImg,
      userFullname: userFullname,
      groupId: groupId, 
      groupName: groupName,
      groupImage: groupImage, 
      joined: joined,
      role: role,
      relationship: relationship);

  }
}