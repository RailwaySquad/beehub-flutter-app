import 'dart:developer';

import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/requirementForm.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:flutter/material.dart';

class BeehubButton{
  static Widget AddFriend(int receiverId ){
    return OutlinedButton(
              onPressed: () async{
                int idUser = await DatabaseProvider().getUserId();
                Requirementform req = Requirementform(senderId: idUser, receiverId: receiverId, type: "ADD_FRIEND");
                log(req.toString());
                var response = await THttpHelper.createRequirement(req);
                log(response.toString());
              },
              child: const Text("Add Friend", style: TextStyle(color: TColors.buttonPrimary),),
            );
  }
}