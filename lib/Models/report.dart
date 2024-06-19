import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/post.dart';
import 'package:beehub_flutter_app/Models/report_type.dart';
import 'package:beehub_flutter_app/Models/user.dart';

class Report {
  final int id;
  final User sender;
  final User? targetUser;
  final Group? targetGroup;
  final Post? targetPost;
  final ReportType type;
  final String? addDescription;
  final DateTime? createAt;
  final DateTime? updateAt;

  Report({required this.id, required this.sender,  this.targetUser,  this.targetGroup,  this.targetPost, required this.type, this.addDescription,  this.createAt,  this.updateAt});
  factory Report.fromJson(Map<String, dynamic> json){
    final id = json['id'];
    final sender = User.fromJson(json['sender']);
    final targetUser = json["target_user"]!=null? User.fromJson(json["target_user"]):null;
    final targetGroup = json["target_group"]!=null? Group.fromJson(json["target_group"]):null;
    final targetPost = json["target_post"]!=null? Post.fromJson(json["target_post"]):null;
    final type = ReportType.fromJson(json["type"]);
    final addDescription = json["add_description"]??'';
    final createAt = json["create_at"]!=null? DateTime.parse(json['create_at']):null;
    final updateAt = json["update_at"]!=null? DateTime.parse(json["update_at"]):null;
    return Report(
      id: id, 
      sender: 
      sender, 
      type: type,
      addDescription: addDescription,
      createAt: createAt,
      targetGroup: targetGroup,
      targetPost: targetPost,
      targetUser: targetUser,
      updateAt: updateAt);
  }
}