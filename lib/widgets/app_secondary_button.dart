import 'package:brijraj_app/constants/color_constants.dart';
import 'package:brijraj_app/styles/textstyles.dart';
import 'package:brijraj_app/widgets/app_spacings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    super.key,
    required this.onPressed,
    required this.buttonHeight,
    this.buttonWidth = double.infinity,
    required this.title,
    required this.icon,
    this.titleColor = kColorwhite,
    this.titleSize = FontSize.k24FontSize,
    this.buttonColor = kColorPrimary,
  });

  final VoidCallback onPressed;
  final double buttonHeight;
  final double? buttonWidth;
  final String title;
  final String icon;
  final Color? titleColor;
  final double? titleSize;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: buttonColor!,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon),
            AppSpaces.h10,
            Text(
              title,
              style: TextStyles.kBoldInstrumentSans(
                fontSize: titleSize!,
                color: titleColor!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
