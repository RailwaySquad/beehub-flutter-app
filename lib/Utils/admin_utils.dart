import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:flutter/material.dart';

Widget getReportType(String type, int? number) {
  String count = '';
  if (number != null) count = number > 1 ? '$number ' : '';
  switch (type) {
    case 'nudity':
    case 'spam':
    case 'drugs':
      return Badge(
        label: Text('$count$type'),
        backgroundColor: Colors.yellow[900],
      );
    case 'violence':
    case 'involve a child':
      return Badge(
        label: Text('$count$type'),
        backgroundColor: Colors.red,
      );
    default:
      return Badge(
        label: Text('$count$type'),
        backgroundColor: Colors.grey,
      );
  }
}

List<Widget> getMultipleReportType(List<String> data) {
  if (data.isEmpty) return [];
  Map<String, int> count = _countDuplicate(data);
  return count.keys.map((key) => getReportType(key, count[key])).toList();
}

_countDuplicate(List<String> data) {
  Map<String, int> count = {};
  for (var d in data) {
    count[d] = (count[d] ?? 0) + 1;
  }
  return count;
}

Widget getGender(String type) {
  switch (type) {
    case 'male':
      return Icon(
        Icons.male,
        color: Colors.blue[900],
      );
    case 'female':
      return Icon(
        Icons.female,
        color: Colors.red[600],
      );
    default:
      return Text(type);
  }
}

getRole(String type) {
  switch (type) {
    case 'ROLE_ADMIN':
      return Badge(
        label: const Text('Admin'),
        backgroundColor: Colors.blue[600],
      );
    case 'ROLE_USER':
      return Badge(
        label: const Text('User'),
        backgroundColor: Colors.grey[400],
      );
    default:
      return Text(type);
  }
}

getStatus(String type) {
  switch (type) {
    case 'active':
      return Badge(
        label: const Text('Active'),
        backgroundColor: Colors.green[600],
      );
    case 'inactive':
      return Badge(
        label: const Text('Inactive'),
        backgroundColor: Colors.red[400],
      );
    case 'banned':
      return Badge(
        label: const Text('Banned'),
        backgroundColor: Colors.grey[400],
      );
    case 'blocked':
      return Badge(
        label: const Text('Blocked'),
        backgroundColor: Colors.red[400],
      );
    default:
      return Text(type);
  }
}

String getAvatar(String avatar) {
  if (avatar == "") {
    return "male";
  } else if (avatar == "male") {
    return "${AppUrl.srcPath}/user_male.png";
  } else if (avatar == "female") {
    return "${AppUrl.srcPath}/user_female.png";
  } else if (avatar == "group") {
    return "${AppUrl.srcPath}/group_image.png";
  } else {
    return avatar;
  }
}

infoList(String title, List<Widget> content) {
  return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        ...content
      ]);
}
