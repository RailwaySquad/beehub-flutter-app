import 'package:beehub_flutter_app/Models/group.dart';
import 'package:beehub_flutter_app/Models/user.dart';

class Requirement{
  final int? id;
  final int senderId;
  final int? receiverId;
  final int? groupId;
  final int? reportId;
  final String? type;
  final bool? isAccept;
  final DateTime? createAt;
  final User? sender;
  final User? receiver;
  final Group? group;

  Requirement({ this.id,required this.senderId,  this.receiverId,  this.groupId,  this.reportId, this.type, this.isAccept, this.createAt, this.sender, this.receiver, this.group});
  Map<String, dynamic> toJson(){
    return {
      "id": id ??"",
      "sender_id": senderId,
      "receiver_id": receiverId??"",
      "group_id": groupId??"",
      "report_id": reportId??"",
      "type": type,
    };
  }
  factory Requirement.fromJson(Map<String, dynamic> json) {
    final id = json["id"];
    final senderId =json["sender_id"]??json["sender"]["id"];
    final receiverId = json["receiver_id"];
    final groupId = json["group_id"];
    final reportId = json["report_id"];
    final type = json["type"];
    final isAccept = json["is_accept"];
    final createAt = json["create_at"]!=null?DateTime.parse(json["create_at"]):null;
    final sender = json["sender"]!=null? User.fromJson(json["sender"]):null;
    final receiver = json["receiver"]!=null? User.fromJson(json["receiver"]):null;
    final group = json["group"]!=null?Group.fromJson(json["group"]):null;
    return Requirement(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      groupId: groupId,
      reportId: reportId,
      type: type,
      isAccept: isAccept,
      createAt: createAt,
      sender: sender,
      receiver: receiver,
      group: group );
  }
  @override
  String toString() {
    return "SenderId : $senderId \tReceiverId: $receiverId \t Type: $type \t GroupId: $groupId"; 
  }
}