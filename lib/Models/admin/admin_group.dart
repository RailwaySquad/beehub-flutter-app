class Group {
  final int id;
  final String name;
  final bool isPublic;
  final int creatorId;
  final String creatorUsername;
  final String creatorImage;
  final int noOfMembers;
  final int noOfPosts;
  final bool isActive;
  final String createdAt;
  final String avatar;
  final List<String> gallery;
  final List<String> reportTitleList;

  Group({
    required this.id,
    required this.name,
    required this.isPublic,
    required this.creatorId,
    required this.creatorUsername,
    required this.creatorImage,
    required this.noOfMembers,
    required this.noOfPosts,
    required this.isActive,
    required this.createdAt,
    required this.avatar,
    required this.gallery,
    required this.reportTitleList
  });
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'] ?? '',
      isPublic: json['public'],
      creatorId: json['creatorId'] ?? 0,
      creatorUsername: json['creatorUsername'] ?? '',
      creatorImage: json['creatorImage'] ?? '',
      noOfMembers: json['noOfMembers'] ?? 0,
      noOfPosts: json['noOfPosts'] ?? 0,
      isActive: json['active'],
      createdAt: json['createdAt'] ?? '',
      avatar: json['avatar'] ?? '',
      gallery: json['gallery'] != null ? (json['gallery'] as List).map((e) => e as String).toList() : [],
      reportTitleList: json['reportTitleList'] != null ? (json['reportTitleList'] as List).map((e) => e as String).toList() : [],
    );
  }
}