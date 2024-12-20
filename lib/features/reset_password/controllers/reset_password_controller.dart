import 'package:brijraj_app/features/login/screens/login_screen.dart';
import 'package:brijraj_app/features/reset_password/services/reset_password_service.dart';
import 'package:brijraj_app/utils/alert_message_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  var isLoading = false.obs;

  var obscuredNewPassword = true.obs;
  void toggleNewPasswordVisibility() {
    obscuredNewPassword.value = !obscuredNewPassword.value;
  }

  var obscuredConfirmPassword = true.obs;
  void toggleConfirmPasswordVisibility() {
    obscuredConfirmPassword.value = !obscuredConfirmPassword.value;
  }

  var hasAttemptedSubmit = false.obs;

  @override
  void onInit() {
    super.onInit();
    setupValidationListeners();
  }

  void setupValidationListeners() {
    newPasswordController.addListener(validateForm);
    confirmPasswordController.addListener(validateForm);
  }

  void validateForm() {
    if (hasAttemptedSubmit.value) {
      formKey.currentState?.validate();
    }
  }

  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> resetPassword({
    required String userName,
  }) async {
    isLoading.value = true;

    try {
      var response = await ResetPasswordService.resetPassword(
        username: userName,
        password: newPasswordController.text,
      );

      secureStorage.delete(
        key: 'fullName',
      );
      secureStorage.delete(
        key: 'userName',
      );

      Get.offAll(
        () => LoginScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(
          milliseconds: 300,
        ),
      );

      showSuccessSnackbar(
        'Success',
        response['message'],
      );
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
