class GroupForm{
  final int? id;
  final String groupname;
  final bool publicGroup;
  final String? description;

  GroupForm({required this.id, required this.groupname, required this.publicGroup, required this.description});
   Map<String, dynamic> toJson() {
      return {
        'id': id,  
        'groupname': groupname,
        'public_group': publicGroup,
        'description': description,
      };
  } 
}