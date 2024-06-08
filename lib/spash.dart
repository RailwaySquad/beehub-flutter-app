import 'package:beehub_flutter_app/Provider/db_provider.dart';
import 'package:beehub_flutter_app/Screens/Authentication/login.dart';
import 'package:beehub_flutter_app/Screens/home_page.dart';
import 'package:beehub_flutter_app/Utils/page_navigator.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator.adaptive()),
    );
  }

  void navigate() {
    Future.delayed(const Duration(seconds: 3), () {
      DatabaseProvider().getToken().then((value) {
        if (value == '') {
          PageNavigator(ctx: context).nextPageOnly(page: const LoginPage());
        } else {
          PageNavigator(ctx: context).nextPageOnly(page: const HomePage());
        }
      });
    });
  }
}