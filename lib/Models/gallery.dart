class Gallery{
  final num id;
  final num userId;
  final num? postId; 
  final String media;
  final String mediaType;
  final DateTime createAt;

  Gallery({required this.id, required this.userId, this.postId, required this.media, required this.mediaType, required this.createAt});
  
  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "user_id": userId,
      "post_id": postId,
      "media": media,
      "media_type": mediaType,
      "create_at": createAt.toString(),
    };
  }
  factory Gallery.fromJson(Map<String, dynamic> json){
    final id = json['id'] as int;
    final user = json['user_id'] as num;
    final post = json['post_is'] as num;
    final media = json['media'] as String;
    final mediaType = json['media_type'] as String;
    final createAt = DateTime.parse(json['create_at'] );
    return Gallery(
          id:id,
          userId:user, 
          postId: post,
          media: media,
          mediaType: mediaType,
          createAt: createAt
          );
  
  }
}