import 'package:beehub_flutter_app/Models/group_media.dart';
import 'package:beehub_flutter_app/Models/group_member.dart';
import 'package:beehub_flutter_app/Models/report.dart';
import 'package:beehub_flutter_app/Models/requirement.dart';
class Group{
  final int? id;
  final String groupname;
  final bool publicGroup;
  final String? description;
  final bool active;
  final DateTime? createdAt;
  final String? imageGroup;
  final String? backgroundGroup;
  final String? joined;
  final String? memberRole;
  final int? memberCount;
  final int? postCount;
  final List<Requirement>? requirements;
  final List<GroupMember>? groupMembers;
  final List<GroupMedia>? groupMedias;
  final List<Report>? reportsOfGroup;
  Group({this.id, required this.groupname, required this.publicGroup,  this.description, required this.active, required this.createdAt,  this.imageGroup,  this.backgroundGroup, this.joined,  this.memberRole, this.memberCount, this.postCount,  this.requirements, this.groupMembers,this.groupMedias,this.reportsOfGroup });
  Map<String, dynamic> toJson() {
      return {
        'id': id,  
        'groupname': groupname,
        'public_group': publicGroup,
        'description': description,
        'active' : active,
        'created_at': createdAt,
        'image_group':imageGroup,
        'background_group': backgroundGroup,
        'joined': joined
      };
  } 
  factory Group.fromJson(Map<String, dynamic> json) {
    final id = json['id'] ;
    final groupname = json['groupname'] ?? '';
    final public = json['public_group'] as bool;
    final description = json['description'] ??'';
    final active = json['active'] as bool;
    final createdAt = json['created_at']!=null? DateTime.parse(json["created_at"]):null;
    final imgGr = json['image_group'];
    final bgGr = json['background_group'];
    final joined = json['joined'];
    final memberRole = json['member_role'];
    final memberCount = json['member_count'] as int;
    final postCount = json["post_count"] as int;
    final List<Requirement> requirements = json["requirements"]!=null? List.from( json["requirements"].map((e)=> Requirement.fromJson(e)) ):[];
    final List<GroupMember> groupMem = json["group_members"]!=null? List.from(json["group_members"].map((e)=> GroupMember.fromJson(e))) :[];
    final List<Report> reports= json["reports_of_group"]!=null? List.from(json["reports_of_group"].map((e) =>  Report.fromJson(e))):[]; 
    final List<GroupMedia> medias = json["group_medias"]!=null? List.from(json["group_medias"].map((e)=> GroupMember.fromJson(e))):[];
    
    return Group(
          id:id,
          groupname:groupname, 
          publicGroup: public,
          description: description,
          active:active,
          createdAt:createdAt,
          imageGroup: imgGr,
          backgroundGroup: bgGr,
          joined: joined,
          memberCount: memberCount,
          memberRole: memberRole,
          postCount: postCount,
          groupMedias: medias,
          groupMembers: groupMem,
          reportsOfGroup: reports,
          requirements: requirements
          );
  }

}