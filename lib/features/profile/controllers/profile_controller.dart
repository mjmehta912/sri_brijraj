import 'package:brijraj_app/features/login/screens/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  var isLoading = false.obs;

  var fullName = ''.obs;
  var userName = ''.obs;

  Future<void> loadFullName() async {
    fullName.value = await secureStorage.read(
          key: 'fullName',
        ) ??
        '';
  }

  Future<void> loadUserName() async {
    userName.value = await secureStorage.read(
          key: 'userName',
        ) ??
        '';
  }

  Future<void> logOut() async {
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
  }
}
