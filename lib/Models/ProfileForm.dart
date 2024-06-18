import 'package:beehub_flutter_app/Models/profile.dart';

class Profileform{
  int id;
  String? fullname;
  String gender;
  String? bio;
  DateTime birthday;
  String? phone;
  Profileform({required this.id, this.fullname, required this.gender, this.bio, this.phone,required this.birthday});
  Map<String, dynamic> toJson() {
    return {
      'id': id,  
      'fullname': fullname,
      'gender' : gender,
      'bio': bio,
      'birthday': birthday.toString(),
      'phone': phone
    };
  } 
  factory Profileform.form(Profile profile){
    return Profileform(
      id: profile.id, 
      gender: profile.gender,
      bio: profile.bio,
      birthday: profile.birthday??DateTime.now(),
      fullname: profile.fullname,
      phone: profile.phone
      );
  }
  @override
  String toString() {
    
    return "Form Submit: \nId : $id \tFullname: $fullname\tGender: $gender\tPhone:$phone\tBirthday: $birthday\nBio: $bio";
  }
}