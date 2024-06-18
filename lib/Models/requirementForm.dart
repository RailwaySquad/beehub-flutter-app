class Requirementform{
  final int? id;
  final int senderId;
  final int? receiverId;
  final int? groupId;
  final int? reportId;
  final String? type;

  Requirementform({ this.id,required this.senderId,  this.receiverId,  this.groupId,  this.reportId, this.type});
  Map<String, dynamic> toJson(){
    return {
      "id": id ??0,
      "sender_id": senderId,
      "receiver_id": receiverId??0,
      "group_id": groupId??0,
      "report_id": reportId??0,
      "type": type,
    };
  }
  factory Requirementform.fromJson(Map<String, dynamic> json) {
    final id = json["id"];
    final senderId =json["sender_id"]??json["sender"]["id"];
    final receiverId = json["receiver_id"];
    final groupId = json["group_id"];
    final reportId = json["report_id"];
    final type = json["type"];
    return Requirementform(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      groupId: groupId,
      reportId: reportId,
      type: type );
  }
  @override
  String toString() {
    return "SenderId : $senderId \tReceiverId: $receiverId \t Type: $type \t GroupId: $groupId \treportId:$reportId\tid: $id"; 
  }
}