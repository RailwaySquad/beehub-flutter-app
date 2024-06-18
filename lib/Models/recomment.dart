import 'dart:core';

class ReComment {
  final int? id;
  final String reaction;
  final int post;
  final int user;
  final int postComment;
  final String? username;
  final DateTime? createdAt;
  final String? fullname;
  final String? userimage;
  final String? usergender;
  ReComment({
    this.id,
    required this.reaction,
    required this.post,
    required this.user,
    required this.postComment,
    this.username,
    this.createdAt,
    this.fullname,
    this.userimage,
    this.usergender
  });

  get recomment => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reaction': reaction,
      'post': post,
      'user': user,
      'postComment': postComment,
      'username': username,
      'createdAt': createdAt?.toIso8601String(), // Convert to ISO 8601 string
      'fullname' : fullname,
      'userimage': userimage,
      'usergender':usergender
    };
  }

  factory ReComment.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int?;
    final reaction = json['reaction'] ?? '';
    final postid = json['post'] as int;
    final userid = json['user'] as int;
    final commentid = json['postComment'] as int;
    final username = json['username'] ?? '';
    final fullname = json['fullname'] ?? '';
    final userimage = json['userimage'] ?? '';
    final usergender = json['usergender'] ?? '';
    final createdAtString = json['createdAt'] as String?;
    DateTime? createdAt;

    if (createdAtString != null) {
      createdAt = DateTime.parse(createdAtString);
    }

    return ReComment(
      id: id,
      reaction: reaction,
      post: postid,
      user: userid,
      postComment: commentid,
      username: username,
      fullname: fullname,
      userimage:userimage,
      usergender:usergender,
      createdAt: createdAt,
    );
  }
}