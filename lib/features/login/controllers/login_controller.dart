import 'package:brijraj_app/features/bottom_nav/screens/bottom_nav_screen.dart';
import 'package:brijraj_app/features/login/services/login_service.dart';
import 'package:brijraj_app/utils/alert_message_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  var isLoading = false.obs;

  var obscuredText = true.obs;
  void togglePasswordVisibility() {
    obscuredText.value = !obscuredText.value;
  }

  var mobileNumberController = TextEditingController();
  var passwordController = TextEditingController();
  var hasAttemptedLogin = false.obs;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    setupValidationListeners();
  }

  void setupValidationListeners() {
    mobileNumberController.addListener(validateForm);
    passwordController.addListener(validateForm);
  }

  void validateForm() {
    if (hasAttemptedLogin.value) {
      formKey.currentState?.validate();
    }
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      var response = await LoginService.login(
        username: mobileNumberController.text,
        password: passwordController.text,
        fcmToken: '',
      );

      if (response.isNotEmpty) {
        await secureStorage.write(
          key: 'userType',
          value: response['userType'].toString(),
        );
        await secureStorage.write(
          key: 'fullName',
          value: response['fullName'],
        );
        await secureStorage.write(
          key: 'userName',
          value: response['username'],
        );
      }

      Get.to(
        () => BottomNavScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(
          milliseconds: 300,
        ),
      );
    } catch (e) {
      showErrorSnackbar(
        'Login Failed',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
