import 'package:brijraj_app/constants/color_constants.dart';
import 'package:brijraj_app/features/bottom_nav/screens/bottom_nav_screen.dart';
import 'package:brijraj_app/features/login/screens/login_screen.dart';
import 'package:brijraj_app/styles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    String? fullName = await _secureStorage.read(key: 'fullName');

    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (fullName != null && fullName.isNotEmpty) {
          Get.offAll(
            () => BottomNavScreen(),
            transition: Transition.fadeIn,
            duration: const Duration(
              milliseconds: 300,
            ),
          );
        } else {
          Get.offAll(
            () => LoginScreen(),
            transition: Transition.fadeIn,
            duration: const Duration(
              milliseconds: 300,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorPrimary,
      body: Center(
        child: Text(
          'SRI BRIJRAJ',
          style: TextStyles.kBoldInstrumentSans(
            fontSize: 40,
            color: kColorwhite,
          ),
        ),
      ),
    );
  }
}
