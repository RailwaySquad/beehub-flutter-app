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

  Profile({required this.id, required this.username, required this.email, required this.fullname, required this.gender, this.image, this.background, this.bio, this.birthday, required this.isActive,  this.relationshipWithUser,  this.activeAt, required this.isBanned});

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
      'is_banned': isBanned
    };
  } 
  factory Profile.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final username = json['username'] ?? '';
    final email = json['email'] ??'';
    final fullname = json['fullname'] ??'';
    final gender = json['gender'];
    final image = json['image'] ?? '';
    final background = json['background'];
    final bio = json['bio'];
    final birthday = json['birthday'] ;
    final isActive = json['is_active'] ?? '';
    final relationshipWithUser= json['relationship_with_user'] ?? '';
    final activeAt= json['active_at'] ?? '' ;
    final isBanned = json['is_banned']??'';
    return Profile(
          id:id,
          username:username, 
          fullname: fullname,
          email: email,
          gender: gender,
          image: image,
          bio: bio,
          birthday: birthday,
          isActive: isActive,
          relationshipWithUser: relationshipWithUser,
          activeAt: activeAt,
          background: background,
          isBanned: isBanned
          );
  }
}