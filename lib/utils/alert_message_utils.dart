import 'package:brijraj_app/constants/color_constants.dart';
import 'package:brijraj_app/styles/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorSnackbar(
  String title,
  String message,
) {
  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: kColorRed,
    duration: const Duration(
      seconds: 3,
    ),
    margin: const EdgeInsets.all(10),
    borderRadius: 15,
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(
      milliseconds: 750,
    ),
    titleText: Text(
      title,
      style: TextStyles.kBoldInstrumentSans(
        color: kColorwhite,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyles.kMediumInstrumentSans(
        fontSize: FontSize.k16FontSize,
        color: kColorwhite,
      ),
    ),
    mainButton: TextButton(
      onPressed: () {
        Get.back();
      },
      child: Text(
        'OK',
        style: TextStyles.kBoldInstrumentSans(
          color: kColorwhite,
        ),
      ),
    ),
  );
}

void showSuccessSnackbar(
  String title,
  String message,
) {
  Get.snackbar(
    '',
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: kColorGreen,
    duration: const Duration(
      seconds: 3,
    ),
    margin: const EdgeInsets.all(10),
    borderRadius: 15,
    isDismissible: true,
    forwardAnimationCurve: Curves.easeOutBack,
    reverseAnimationCurve: Curves.easeInBack,
    animationDuration: const Duration(
      milliseconds: 750,
    ),
    titleText: Text(
      title,
      style: TextStyles.kBoldInstrumentSans(
        color: kColorwhite,
      ),
    ),
    messageText: Text(
      message,
      style: TextStyles.kMediumInstrumentSans(
        fontSize: FontSize.k16FontSize,
        color: kColorwhite,
      ),
    ),
    mainButton: TextButton(
      onPressed: () {
        Get.back();
      },
      child: Text(
        'OK',
        style: TextStyles.kBoldInstrumentSans(
          color: kColorwhite,
        ),
      ),
    ),
  );
}
