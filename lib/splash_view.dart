import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shipping_address/common/helper/constant.dart';
import 'package:shipping_address/common/routes/route.dart';
import 'package:shipping_address/generated/assets.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Future<void> checkTokenAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(Constant.kPrefToken);
    final routeName = token != null ? AppRoute.listAddress : AppRoute.login;
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  void initState() {
    checkTokenAndNavigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(Assets.assetsIconsIcLoading, width: 80, height: 80),
      ),
    );
  }
}
