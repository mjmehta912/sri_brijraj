import 'package:brijraj_app/constants/color_constants.dart';
import 'package:brijraj_app/styles/textstyles.dart';
import 'package:brijraj_app/widgets/app_paddings.dart';
import 'package:brijraj_app/widgets/app_size_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines = 1,
    this.onChanged,
    this.validator,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.fillColor = kColorwhite,
    this.suffixIcon,
    this.isObscure = false,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final bool? enabled;
  final int? maxLines;
  final int? minLines;
  final void Function(String value)? onChanged;
  final String? Function(String? value)? validator;
  final String hintText;
  final TextInputType? keyboardType;
  final Color? fillColor;
  final Widget? suffixIcon;
  final bool? isObscure;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: kColorSecondary,
      inputFormatters: inputFormatters,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      validator: validator,
      onChanged: onChanged,
      keyboardType: keyboardType,
      style: TextStyles.kMediumInstrumentSans(
        fontSize: FontSize.k20FontSize,
        color: kColorSecondary,
      ),
      obscureText: isObscure!,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyles.kRegularInstrumentSans(
          fontSize: FontSize.k16FontSize,
          color: kColorLightGrey,
        ),
        errorStyle: TextStyles.kMediumInstrumentSans(
          fontSize: FontSize.k16FontSize,
          color: kColorRed,
        ),
        border: InputBorder.none,
        focusedBorder: underlineInputBorder(
          borderColor: kColorPrimary,
          borderWidth: 1.5,
        ),
        enabledBorder: underlineInputBorder(
          borderColor: kColorPrimary,
          borderWidth: 1.5,
        ),
        errorBorder: underlineInputBorder(
          borderColor: kColorRed,
          borderWidth: 1.5,
        ),
        contentPadding: AppPaddings.combined(
          horizontal: 16.appWidth,
          vertical: 8.appHeight,
        ),
        filled: true,
        fillColor: fillColor,
        suffixIcon: suffixIcon,
        suffixIconColor: kColorPrimary,
      ),
    );
  }

  UnderlineInputBorder underlineInputBorder({
    required Color borderColor,
    required double borderWidth,
  }) {
    return UnderlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }
}
