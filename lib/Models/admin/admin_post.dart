class Post {
  final int id;
  final int creatorId;
  final String creatorUsername;
  final String creatorImage;
  final String timestamp;
  final String content;
  final String image;
  final bool isBlocked;
  final List<String> reportTitleList;

  Post(
      {required this.id,
      required this.creatorId,
      required this.creatorUsername,
      required this.creatorImage,
      required this.timestamp,
      required this.content,
      required this.image,
      required this.isBlocked,
      required this.reportTitleList,
      });
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      creatorId: json['creatorId'],
      creatorUsername: json['creatorUsername'],
      creatorImage: json['creatorImage'] ?? '',
      timestamp: json['timestamp'],
      content: json['content'] ?? '',
      image: json['image'] ?? '',
      isBlocked: json['isBlocked'],
      reportTitleList: (json['reportTitleList'] as List).map((e) => e as String).toList(),
    );
  }
}