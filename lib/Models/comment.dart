import 'dart:core';

class Comment {
  final int? id;
  final String comment;
  final int post;
  final int user;
  final String? username;
  final DateTime? createdAt;
  final String? fullname;
  Comment({
    this.id,
    required this.comment,
    required this.post,
    required this.user,
    this.username,
    this.createdAt,
    this.fullname
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'post': post,
      'user': user,
      'username': username,
      'createdAt': createdAt?.toIso8601String(), // Convert to ISO 8601 string
      'fullname' : fullname
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int?;
    final comment = json['comment'] ?? '';
    final postid = json['post'] as int;
    final userid = json['user'] as int;
    final username = json['username'] ?? '';
    final fullname = json['fullname'] ?? '';
    final createdAtString = json['createdAt'] as String?;
    DateTime? createdAt;

    if (createdAtString != null) {
      createdAt = DateTime.parse(createdAtString);
    }

    return Comment(
      id: id,
      comment: comment,
      post: postid,
      user: userid,
      username: username,
      fullname: fullname,
      createdAt: createdAt,
    );
  }
}