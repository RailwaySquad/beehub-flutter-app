class User {
  final int id;
  final String username;
  final String email;
  final String fullName;
  final String gender;
  final int noOfPosts;
  final int noOfFriends;
  final String role;
  final String status;
  final String createdAt;
  final String avatar;
  final List<String> gallery;
  final List<String> reportTitleList;
  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.fullName,
      required this.gender,
      required this.noOfPosts,
      required this.noOfFriends,
      required this.role,
      required this.status,
      required this.createdAt,
      required this.avatar,
      required this.gallery,
      required this.reportTitleList,
      });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      fullName: json['fullName'] ?? '',
      gender: json['gender'] ?? '',
      noOfPosts: json['noOfPosts'],
      noOfFriends: json['noOfFriends'],
      role: json['role'],
      status: json['status'],
      createdAt: json['createdAt'],
      avatar: json['avatar'] ?? '',
      gallery: json['gallery'] != null ? (json['gallery'] as List).map((e) => e as String).toList() : [],
      reportTitleList: (json['reportTitleList'] as List).map((e) => e as String).toList(),
    );
  }
}
