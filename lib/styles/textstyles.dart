import 'package:brijraj_app/constants/color_constants.dart';
import 'package:flutter/material.dart';

class Fonts {
  static const instrumentSansRegular = 'InstrumentSansRegular';
  static const instrumentSansMedium = 'InstrumentSansMedium';
  static const instrumentSansSemiBold = 'InstrumentSansSemiBold';
  static const instrumentSansBold = 'InstrumentSansBold';
}

class FontSize {
  static const double k10FontSize = 10;
  static const double k12FontSize = 12;
  static const double k14FontSize = 14;
  static const double k16FontSize = 16;
  static const double k18FontSize = 18;
  static const double k20FontSize = 20;
  static const double k22FontSize = 22;
  static const double k24FontSize = 24;
  static const double k26FontSize = 26;
  static const double k28FontSize = 28;
  static const double k30FontSize = 30;
  static const double k32FontSize = 32;
  static const double k34FontSize = 34;
  static const double k36FontSize = 36;
  static const double k40FontSize = 40;
}

class TextStyles {
  static TextStyle kRegularInstrumentSans({
    double fontSize = FontSize.k20FontSize,
    Color color = kColorBlack,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.instrumentSansRegular,
    );
  }

  static TextStyle kMediumInstrumentSans({
    double fontSize = FontSize.k20FontSize,
    Color color = kColorBlack,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.instrumentSansMedium,
    );
  }

  static TextStyle kSemiBoldInstrumentSans({
    double fontSize = FontSize.k20FontSize,
    Color color = kColorBlack,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.instrumentSansSemiBold,
    );
  }

  static TextStyle kBoldInstrumentSans({
    double fontSize = FontSize.k20FontSize,
    Color color = kColorBlack,
    FontWeight fontWeight = FontWeight.w700,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: Fonts.instrumentSansBold,
    );
  }
}
