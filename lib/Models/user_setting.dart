class UserSetting{
  final int? id;
  final int? userId;
  final int? postId;
  final String settingType;
  final String? settingItem;

  UserSetting({this.id,  this.userId, required this.postId, required this.settingType, required this.settingItem});
  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "user_id": userId,
      "post_id": postId,
      "setting_type": settingType,
      "setting_item": settingItem,
    };
  }
   factory UserSetting.fromJson(Map<String, dynamic> json){
      final id = json['id'];
      final user = json['user_id'] ;
      final post = json['post_is'] ;
      final settingType = json['setting_type'];
      final settingItem = json['setting_item'];
      return UserSetting(
        id: id, 
        userId: user, 
        postId: post, 
        settingType: settingType, 
        settingItem: settingItem
        );
   }
}