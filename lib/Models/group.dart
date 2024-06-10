class Group{
  final num id;
  final String groupname;
  final bool publicGroup;
  final String description;
  final bool active;
  final String createdAt;
  final String imageGroup;
  final String backgroundGroup;
  final String joined;
  final String memberRole;
  final int memberCount;

  Group({required this.id, required this.groupname, required this.publicGroup, required this.description, required this.active, required this.createdAt, required this.imageGroup, required this.backgroundGroup, required this.joined, required this.memberRole, required this.memberCount});
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
        'joined': joined,
        'member_role': memberRole,
        'member_count': memberCount
      };
  } 
  factory Group.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final groupname = json['groupname'] ?? '';
    final public = json['public_group'] ==1? true: false;
    final description = json['description'] ??'';
    final active = json['active'] ==1 ? true :false;
    final createdAt = json['created_at'] ?? '';
    final imgGr = json['image_group'] ?? '';
    final bgGr = json['background_group'] ?? '';
    final joined = json['joined'] ?? '';
    final memberRole = json['member_role'] ??'';
    final memberCount = json['member_count'] as int;
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
          memberRole: memberRole
          );
  }

}