class User {
  final int id;
  final String username;
  final String fullname;
  final String gender;
  final String? image;
  final String? imageType;
  final String? typeRelationship;
  final bool isBanned;
  final int? groupCounter;
  final int? friendCounter;

  User({required this.id, required this.username, required this.fullname, required this.gender, this.image, this.imageType, this.typeRelationship, required this.isBanned, this.groupCounter, this.friendCounter});
  Map<String, dynamic> toJson() {
    return {
      'id': id,  
      'username': username,
      'fullname': fullname,
      'gender': gender,
      'image' : image,
      'image_type': imageType,
      'typeRelationship':typeRelationship,
      'is_banned': isBanned,
      'group_counter': groupCounter,
      'friend_counter':friendCounter
    };
  } 
  factory User.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final username = json['username'] ?? '';
    final fullname = json['fullname'] ??'';
    final gender = json['gender'] ??'';
    final image= json['image'];
    final imageType = json['image_type'];
    final typeRelationship = json['typeRelationship'];
    final banned= json['is_banned'] ==1 ? true:false;
    final groupCounter = json['group_counter'] ;
    final friendCounter = json['friend_counter'];
    return User(
          id:id,
          username:username, 
          fullname: fullname,
          gender:gender,
          image:image,
          imageType: imageType,
          typeRelationship: typeRelationship,
          isBanned: banned,
          groupCounter:groupCounter,
          friendCounter: friendCounter
          );
  }
  @override
  String toString() {
    // TODO: implement toString
    return "User $username \t$typeRelationship \t$isBanned";
  }
}