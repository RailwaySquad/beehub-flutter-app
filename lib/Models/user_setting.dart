class UserSetting{
  final int id;
  final int userId;
  final int? postId;
  final String settingType;
  final String? settingItem;

  UserSetting({required this.id, required this.userId, required this.postId, required this.settingType, required this.settingItem});
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
      final id = json['id'] as int;
      final user = json['user_id'] as int;
      final post = json['post_is'] as int;
      final settingType = json['setting_type'] as String;
      final settingItem = json['setting_item'] as String;
      return UserSetting(
        id: id, 
        userId: user, 
        postId: post, 
        settingType: settingType, 
        settingItem: settingItem
        );
   }
}