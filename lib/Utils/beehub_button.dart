import 'dart:developer';

import 'package:beehub_flutter_app/Constants/color.dart';
import 'package:beehub_flutter_app/Models/requirementForm.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Utils/api_connection/http_client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BeehubButton{
  static Widget AddFriend(int receiverId, String routeName,String? search ){
    return ElevatedButton(
              onPressed: () async{
                int idUser = await DatabaseProvider().getUserId();
                Requirementform req = Requirementform(senderId: idUser, receiverId: receiverId, type: "ADD_FRIEND");
                var response = await THttpHelper.createRequirement(req);
                if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                  Get.toNamed(routeName,arguments: search,preventDuplicates: false);
                }
              },
              style:  ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor: WidgetStateProperty.all<Color>(TColors.buttonPrimary),
              ),
              child: const Text("Add Friend", style: TextStyle(fontWeight: FontWeight.w600),),
            );
  }
  static Widget UnBlock(int receiverId, String routeName,String? search ){
    return ElevatedButton(
              onPressed: () async{
                int idUser = await DatabaseProvider().getUserId();
                Requirementform req = Requirementform(senderId: idUser, receiverId: receiverId, type: "UN_BLOCK");
                var response = await THttpHelper.createRequirement(req);
                if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                  Get.toNamed(routeName,arguments: search,preventDuplicates: false);
                }
              },
              style: ButtonStyle(
                foregroundColor:  WidgetStateProperty.all<Color>(Colors.red),
                backgroundColor:  WidgetStateProperty.all<Color>(Colors.white),
              ),
              child: const Text("Unblock", style: TextStyle(fontWeight: FontWeight.w600),),
            );
  }
  static Widget UnFriend(int receiverId ,String routeName,String? search){
    return ElevatedButton(
              onPressed: () async{
                int idUser = await DatabaseProvider().getUserId();
                Requirementform req = Requirementform(senderId: idUser, receiverId: receiverId, type: "UN_FRIEND");
                var response = await THttpHelper.createRequirement(req);
                if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                  Get.toNamed(routeName,arguments: search,preventDuplicates: false);
                }
              },
              style: ButtonStyle(
                foregroundColor:  WidgetStateProperty.all<Color>(TColors.borderPrimary),
                backgroundColor:  WidgetStateProperty.all<Color>(Colors.white),
              ),
              child: const Text("Unfriend", style: TextStyle(fontWeight: FontWeight.w600),),
            );
  }
  static Widget CancelRequest(int receiverId,String routeName,String? search ){
    return ElevatedButton(
              onPressed: () async{
                int idUser = await DatabaseProvider().getUserId();
                Requirementform req = Requirementform(senderId: idUser, receiverId: receiverId, type: "CANCEL_REQUEST");
                var response = await THttpHelper.createRequirement(req);
                if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                  Get.toNamed(routeName,arguments: search,preventDuplicates: false);
                }
              },
              style: ButtonStyle(
                foregroundColor:  WidgetStateProperty.all<Color>(Colors.deepOrange),
                backgroundColor:  WidgetStateProperty.all<Color>(Colors.white),
              ),
              child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.w600),),
            );
  }
  static Widget AcceptFriend(int receiverId, bool disable,String routeName,String? search ){
    return ElevatedButton(
              onPressed: () async{
                if(!disable){
                int idUser = await DatabaseProvider().getUserId();
                Requirementform req = Requirementform(senderId: idUser, receiverId: receiverId, type: "ACCEPT");
                var response = await THttpHelper.createRequirement(req);
                if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                  Get.toNamed(routeName,arguments: search,preventDuplicates: false);
                }
                }
              },
              style: ButtonStyle(
                foregroundColor:  WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor:  WidgetStateProperty.all<Color>(Colors.green),
              ),
              child: const Text("Accept", style: TextStyle(fontWeight: FontWeight.w600),),
            );
  }
  static Widget CancelAddFriend(int senderId, bool disable,String routeName,String? search ){
    return ElevatedButton(
              onPressed: () async{
                if(!disable){
                int idUser = await DatabaseProvider().getUserId();
                Requirementform req = Requirementform(senderId: senderId, receiverId: idUser, type: "CANCEL_ADDFRIEND");
                var response = await THttpHelper.createRequirement(req);
                if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                  Get.toNamed(routeName,arguments: search,preventDuplicates: false);
                }
                }
              },
              style: ButtonStyle(
                foregroundColor:  WidgetStateProperty.all<Color>(Colors.green),
                backgroundColor:  WidgetStateProperty.all<Color>(Colors.white),
              ),
              child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.w600),),
            );
  }
  static Widget BlockUser(int receiverId ,String routeName,String? search ){
    return ElevatedButton(
              onPressed: () async{
                int idUser = await DatabaseProvider().getUserId();
                Requirementform req = Requirementform(senderId: idUser, receiverId: receiverId, type: "BLOCK");
                var response = await THttpHelper.createRequirement(req);
                if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                  Get.toNamed(routeName,arguments: search,preventDuplicates: false);
                }
              },
              style: ButtonStyle(
                foregroundColor:  WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor:  WidgetStateProperty.all<Color>(Colors.red),
              ),
              child: const Text("Block", style: TextStyle(fontWeight: FontWeight.w600),),
            );
  }
  static Widget JoinGroup(int groupId,String routeName,String? search ){
    return ElevatedButton(
              onPressed: () async{
                int idUser = await DatabaseProvider().getUserId();
                Requirementform req = Requirementform(senderId: idUser, groupId: groupId, type: "JOIN");
                var response = await THttpHelper.createRequirement(req);
                if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                  Get.toNamed(routeName,arguments: search,preventDuplicates: false);
                }
              },
              style: ButtonStyle(
                foregroundColor:  WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor:  WidgetStateProperty.all<Color>(TColors.buttonPrimary),
              ),
              child: const Text("Join", style: TextStyle(fontWeight: FontWeight.w600),),
            );
  }
  static Widget CancelJoinGroup(int groupId ,String routeName,String? search){
    return ElevatedButton(
              onPressed: () async{
                int idUser = await DatabaseProvider().getUserId();
                Requirementform req = Requirementform(senderId: idUser, groupId: groupId, type: "CANCEL_JOIN");
                var response = await THttpHelper.createRequirement(req);
                if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                  Get.toNamed(routeName,arguments: search,preventDuplicates: false);
                }
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.black),
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              ),
              child: const Text("Undo", style: TextStyle(fontWeight: FontWeight.w600),),
            );
  }
  static Widget VisitGroup(int groupId ){
    return ElevatedButton(
              onPressed: () async{
                Get.toNamed("/group/$groupId");
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(TColors.buttonPrimary),
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              ),
              child: const Text("Vist", style: TextStyle(fontWeight: FontWeight.w600),),
            );
  }
  static Widget ManagerGroup(int groupId ){
    return ElevatedButton(
              onPressed: () async{
                Get.toNamed("/group/manager/$groupId");
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
              ),
              child: const Text("Manage", style: TextStyle(fontWeight: FontWeight.w600),),
            );
  }
  static Widget LeaveGroup(int groupId, String routeName,String? search ){
    return ElevatedButton(
              onPressed: () async{
                int idUser = await DatabaseProvider().getUserId();
                Requirementform req = Requirementform(senderId: idUser, groupId: groupId, type: "LEAVE_GROUP");
                var response = await THttpHelper.createRequirement(req);
                if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                  Get.toNamed(routeName,arguments: search,preventDuplicates: false);
                }
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              ),
              child: const Text("Leave", style: TextStyle(fontWeight: FontWeight.w600),),
            );
  }
  static Widget RetireManage(int groupId, String routeName,String? search ){
    return ElevatedButton(
              onPressed: () async{
                int idUser = await DatabaseProvider().getUserId();
                Requirementform req = Requirementform(senderId: idUser, groupId: groupId, type: "RETIRE");
                var response = await THttpHelper.createRequirement(req);
                if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                  Get.toNamed("/group/$groupId",arguments: search,preventDuplicates: false);
                }
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.red),
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              ),
              child: const Text("Retire", style: TextStyle(fontWeight: FontWeight.w600),),
            );
  }
  static Widget AcceptJoinGroup(int groupId, int receiverId, String routeName,String? search ){
    return ElevatedButton(
              onPressed: () async{
                int idUser = await DatabaseProvider().getUserId();
                Requirementform req = Requirementform(senderId: idUser, groupId: groupId, receiverId: receiverId, type: "ACCEPT_MEMBER");
                var response = await THttpHelper.createRequirement(req);
                if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                  Get.toNamed(routeName,arguments: search,preventDuplicates: false);
                }
              },
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
              ),
              child: const Text("Accept"),
            );
  }
  static Widget RejectJoinGroup(int groupId, int receiverId , String routeName,String? search){
    return ElevatedButton(
              onPressed: () async{
                int idUser = await DatabaseProvider().getUserId();
                Requirementform req = Requirementform(senderId: idUser, groupId: groupId, receiverId: receiverId, type: "REJECT");
                var response = await THttpHelper.createRequirement(req);
                if(response?["response"]!="unsuccess" && response?["response"]!="error"){
                  Get.toNamed(routeName,arguments: search,preventDuplicates: false);
                }
              },
               style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
              ),
              child: const Text("Reject"),
            );
  }
}
