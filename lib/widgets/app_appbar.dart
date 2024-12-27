import 'package:brijraj_app/constants/color_constants.dart';
import 'package:brijraj_app/styles/textstyles.dart';
import 'package:brijraj_app/widgets/app_size_extensions.dart';
import 'package:flutter/material.dart';

class AppAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final TextStyle? titleStyle;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final double titleSpacing;
  final List<Widget>? actions;

  const AppAppbar({
    super.key,
    this.title = 'SRI BRIJRAJ',
    this.titleStyle,
    this.leading,
    this.automaticallyImplyLeading = false,
    this.titleSpacing = 24.0,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: kColorBackground,
      title: Text(
        title!,
        style: titleStyle ??
            TextStyles.kSemiBoldInstrumentSans(
              fontSize: FontSize.k24FontSize,
              color: kColorPrimary,
            ),
      ),
      titleSpacing: titleSpacing.appWidth,
      leading: leading,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
