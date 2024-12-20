import 'package:brijraj_app/constants/color_constants.dart';
import 'package:brijraj_app/constants/image_constants.dart';
import 'package:brijraj_app/features/add_entry/screens/add_entry_screen.dart';
import 'package:brijraj_app/features/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:brijraj_app/features/history/screens/history_screen.dart';
import 'package:brijraj_app/features/profile/screens/profile_screen.dart';
import 'package:brijraj_app/widgets/app_size_extensions.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({
    super.key,
  });

  final BottomNavController _controller = Get.put(
    BottomNavController(),
  );

  final List<Widget> pages = [
    KeyedPage(
      key: UniqueKey(),
      page: const HistoryScreen(),
    ),
    KeyedPage(
      key: UniqueKey(),
      page: const AddEntryScreen(),
    ),
    KeyedPage(
      key: UniqueKey(),
      page: const ProfileScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! > 0) {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          backgroundColor: kColorBackground,
          body: Obx(
            () => pages[_controller.selectedIndex.value],
          ),
          bottomNavigationBar: CurvedNavigationBar(
            color: kColorwhite,
            buttonBackgroundColor: kColorPrimary,
            backgroundColor: kColorBackground,
            animationDuration: const Duration(
              milliseconds: 100,
            ),
            animationCurve: Curves.bounceIn,
            height: 50.appHeight,
            index: _controller.selectedIndex.value,
            items: [
              Obx(
                () => SvgPicture.asset(
                  _controller.selectedIndex.value == 0
                      ? kIconHistoryFilled
                      : kIconHistory,
                  height: _controller.selectedIndex.value == 0
                      ? 30.appHeight
                      : 25.appHeight,
                ),
              ),
              Obx(
                () => SvgPicture.asset(
                  _controller.selectedIndex.value == 1
                      ? kIconAddFilled
                      : kIconAdd,
                  height: _controller.selectedIndex.value == 1
                      ? 30.appHeight
                      : 25.appHeight,
                ),
              ),
              Obx(
                () => SvgPicture.asset(
                  _controller.selectedIndex.value == 2
                      ? kIconProfileFilled
                      : kIconProfile,
                  height: _controller.selectedIndex.value == 2
                      ? 30.appHeight
                      : 25.appHeight,
                ),
              ),
            ],
            onTap: (index) {
              _controller.changeIndex(index);
            },
          ),
        ),
      ),
    );
  }
}

class KeyedPage extends StatelessWidget {
  final Widget page;
  const KeyedPage({
    required Key key,
    required this.page,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return page;
  }
}
