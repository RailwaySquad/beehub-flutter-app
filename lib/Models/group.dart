class Group{
  final num? id;
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
  Group({this.id, required this.groupname, required this.publicGroup,  this.description, required this.active, required this.createdAt,  this.imageGroup,  this.backgroundGroup, this.joined,  this.memberRole, this.memberCount, this.postCount});
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
          postCount: postCount
          );
  }

}