import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var isLoading = false.obs;

  var selectedIndex = 1.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
