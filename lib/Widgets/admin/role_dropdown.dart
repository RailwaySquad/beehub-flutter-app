import 'dart:convert';

import 'package:beehub_flutter_app/Constants/url.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RoleDropdown extends StatefulWidget {
  final int userId;
  final String role;
  const RoleDropdown({super.key, required this.userId, required this.role});

  @override
  State<RoleDropdown> createState() => _RoleDropdownState();
}

class _RoleDropdownState extends State<RoleDropdown> {
  late String r;
  
  @override
  void initState() {
    r = widget.role;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    updateUserRole(String? value) async {
      final String url = '${AppUrl.adminPath}/users/${widget.userId}/$value';
      http.Response response = await http.patch(Uri.parse(url), headers: {
        'Authorization': 'Bearer ${await DatabaseProvider().getToken()}'
      });
      if (response.statusCode == 200) {
        setState(() {
          r = jsonDecode(response.body);
        });
      }
    }

    return DropdownButton(items: const [
      DropdownMenuItem(value: 'ROLE_USER', child: Text(' User')),
      DropdownMenuItem(value: 'ROLE_ADMIN', child: Text(' Admin')),
    ], value: r, onChanged: updateUserRole);
  }
}
