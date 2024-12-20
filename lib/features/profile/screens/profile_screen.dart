import 'package:brijraj_app/constants/color_constants.dart';
import 'package:brijraj_app/features/profile/controllers/profile_controller.dart';
import 'package:brijraj_app/features/reset_password/screens/reset_password_screen.dart';
import 'package:brijraj_app/styles/textstyles.dart';
import 'package:brijraj_app/widgets/app_button.dart';
import 'package:brijraj_app/widgets/app_paddings.dart';
import 'package:brijraj_app/widgets/app_size_extensions.dart';
import 'package:brijraj_app/widgets/app_spacings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _controller = Get.put(
    ProfileController(),
  );

  @override
  void initState() {
    super.initState();
    _controller.loadFullName();
    _controller.loadUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorBackground,
      body: Padding(
        padding: AppPaddings.ph16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'SRI BRIJRAJ',
              style: TextStyles.kBoldInstrumentSans(
                fontSize: FontSize.k40FontSize,
                color: kColorPrimary,
              ),
            ),
            Obx(
              () => Text(
                _controller.fullName.value,
                style: TextStyles.kSemiBoldInstrumentSans(
                  fontSize: FontSize.k24FontSize,
                  color: kColorSecondary,
                ),
              ),
            ),
            AppSpaces.v50,
            AppButton(
              onTap: () {
                Get.to(
                  () => ResetPasswordScreen(
                    userName: _controller.userName.value,
                  ),
                  transition: Transition.fadeIn,
                  duration: const Duration(
                    milliseconds: 300,
                  ),
                );
              },
              buttonHeight: 40.appHeight,
              title: 'Reset Password',
            ),
            AppSpaces.v20,
            AppButton(
              onTap: () {
                _controller.logOut();
              },
              buttonHeight: 40.appHeight,
              title: 'Log Out',
            ),
          ],
        ),
      ),
    );
  }
}
