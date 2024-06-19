import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingOption extends StatelessWidget {
  const SettingOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Get.toNamed("/");},icon: const Icon(Icons.chevron_left),),
        title: const Text("Account Setting"),
      ),
      body: SingleChildScrollView());
  }
}