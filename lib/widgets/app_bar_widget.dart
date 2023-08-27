import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jointact_case_study/constants/color_constants.dart';

/// Bu widget projenin genelinde ortak bir AppBar sunmak için geliştirilmiştir.
/// Genel değişiklikler (örneğin arkaplan rengi) sadece burada yapılarak tüm uygulamada etkisini gösterir.
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final void Function()? leadingOnPressed;
  const AppBarWidget({super.key, required this.title, this.leadingIcon, this.actions, this.leadingOnPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: primaryColor,
      title: Text(
        title,
        style: const TextStyle(color: appBarForegroundColor, fontSize: 18),
      ),
      leading: leadingIcon != null
          ? IconButton(
              icon: Icon(leadingIcon, color: appBarForegroundColor),
              onPressed: leadingOnPressed ?? () => Navigator.pop(context),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
