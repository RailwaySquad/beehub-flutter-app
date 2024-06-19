import 'package:beehub_flutter_app/Provider/auth_provider.dart';
import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Provider/user_provider.dart';
import 'package:beehub_flutter_app/Screens/AccountSetting/setting_account.dart';
import 'package:beehub_flutter_app/Screens/AccountSetting/setting_general.dart';
import 'package:beehub_flutter_app/Screens/AccountSetting/setting_option.dart';
import 'package:beehub_flutter_app/Screens/AccountSetting/setting_security.dart';
import 'package:beehub_flutter_app/Screens/Group/group_page.dart';
import 'package:beehub_flutter_app/Screens/Search/search_screen.dart';
import 'package:beehub_flutter_app/Screens/user_page.dart';
import 'package:beehub_flutter_app/spash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DatabaseProvider()),
      ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      ChangeNotifierProvider(create: (_)=> UserProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.quicksandTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: ()=> const SplashScreen()),
        GetPage(name: '/search', page: ()=> const SearchScreen()),
        GetPage(name: '/userpage/:user', page: ()=> const UserPage()),
        GetPage(name: '/account_setting', page: ()=> const SettingOption()),
        GetPage(name: '/account_setting/general', page: ()=> const SettingGeneral()),
        GetPage(name: '/account_setting/account', page: ()=> const SettingAccount()),
        GetPage(name: '/account_setting/security', page: ()=> const SettingSecurity()),
        GetPage(name: "/group/:idGroup", page: ()=> const GroupPage())
      ]
    );
  }
}
