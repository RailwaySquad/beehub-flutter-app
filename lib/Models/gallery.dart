class Gallery{
  final int? id;
  final int? userId;
  final int? postId; 
  final String media;
  final String mediaType;
  final DateTime? createAt;

  Gallery({ this.id, this.userId, this.postId, required this.media, required this.mediaType,  this.createAt});
  
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
    final id = json['id'] ;
    final user = json['user_id'];
    final post = json['post_is'];
    final media = json['media'] as String;
    final mediaType = json['media_type'] as String;
    final createAt = json["create_at"] !=null ? DateTime.parse(json["create_at"]):null;
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