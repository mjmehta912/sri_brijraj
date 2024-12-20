import 'package:brijraj_app/constants/color_constants.dart';
import 'package:brijraj_app/styles/textstyles.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onTap,
    required this.buttonHeight,
    this.buttonWidth = double.infinity,
    required this.title,
  });

  final VoidCallback onTap;
  final double buttonHeight;
  final double? buttonWidth;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          gradient: const RadialGradient(
            colors: [
              kColorwhite,
              kColorPrimary,
            ],
            radius: 15,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: kColorPrimary,
            width: 0.25,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyles.kBoldInstrumentSans(
              fontSize: FontSize.k22FontSize,
              color: kColorPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
