import 'package:brijraj_app/constants/color_constants.dart';
import 'package:brijraj_app/features/login/controllers/login_controller.dart';
import 'package:brijraj_app/styles/textstyles.dart';
import 'package:brijraj_app/widgets/app_button.dart';
import 'package:brijraj_app/widgets/app_loading_overlay.dart';
import 'package:brijraj_app/widgets/app_paddings.dart';
import 'package:brijraj_app/widgets/app_size_extensions.dart';
import 'package:brijraj_app/widgets/app_spacings.dart';
import 'package:brijraj_app/widgets/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({
    super.key,
  });

  final LoginController _controller = Get.put(
    LoginController(),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: kColorBackground,
            body: Padding(
              padding: AppPaddings.ph20,
              child: Form(
                key: _controller.formKey,
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
                    AppSpaces.v50,
                    AppTextFormField(
                      controller: _controller.mobileNumberController,
                      hintText: 'Mobile Number / Username',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a valid username';
                        }
                        return null;
                      },
                    ),
                    AppSpaces.v16,
                    Obx(
                      () => AppTextFormField(
                        controller: _controller.passwordController,
                        hintText: 'Password',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a valid password';
                          }
                          return null;
                        },
                        isObscure: _controller.obscuredText.value,
                        suffixIcon: IconButton(
                          onPressed: () {
                            _controller.togglePasswordVisibility();
                          },
                          icon: Icon(
                            _controller.obscuredText.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    AppSpaces.v24,
                    AppButton(
                      onTap: () async {
                        _controller.hasAttemptedLogin.value = true;
                        if (_controller.formKey.currentState!.validate()) {
                          FocusManager.instance.primaryFocus?.unfocus();
                          await _controller.login();
                        }
                      },
                      buttonHeight: 40.appHeight,
                      title: 'Login',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Obx(
          () => CustomLoadingOverlay(
            isLoading: _controller.isLoading.value,
          ),
        ),
      ],
    );
  }
}
