import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/constants/image_constants.dart';
import 'package:jointact_case_study/constants/string_constants.dart';
import 'package:jointact_case_study/helpers/ui_helper.dart';
import 'package:jointact_case_study/localization/app_localization.dart';
import 'package:jointact_case_study/pages/admin/categories_page.dart';
import 'package:jointact_case_study/pages/admin/products_page.dart';
import 'package:jointact_case_study/pages/redirect_page.dart';
import 'package:jointact_case_study/pages/settings_page.dart';

/// Bu sınıf, yönetici panelinde kullanılan gezinme çekmecesini oluşturur.
/// Kullanıcının farklı sayfalara yönlendirilmesini sağlar.
///
/// Temel İşlevler:
///
/// - Kullanıcı Profili: Kullanıcının profil resmini ve adını gösterir.
/// - Menü Öğeleri: Kategori, ürün, ayarlar ve çıkış gibi sayfalara yönlendirme yapar.
///
/// [ConsumerWidget], Riverpod paketinin bir parçasıdır ve widget'in
/// değişen verilere (örneğin, sağlayıcılardan gelen verilere) yanıt vermesini sağlar.
class AdminNavigationDrawer extends ConsumerWidget {
  const AdminNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildHeader(context),
          buildMenuItems(context, ref),
        ],
      )),
    );
  }

  Widget buildHeader(BuildContext context) => Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: UIHelper.getDeviceWidth(context) / 4,
                  height: UIHelper.getDeviceWidth(context) / 4,
                  child: SvgPicture.asset(
                    IconAssetKeys.userTie,
                    width: UIHelper.getDeviceWidth(context) / 4,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  Widget buildMenuItems(BuildContext context, WidgetRef ref) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Divider(color: Colors.black45),
            ListTile(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              leading: const Icon(Icons.category_rounded),
              title: Text(
                getTranslated(context, StringKeys.categories),
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriesPage(),
                  ),
                );
              },
            ),
            ListTile(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              leading: const Icon(Icons.auto_awesome_mosaic_rounded),
              title: Text(
                getTranslated(context, StringKeys.products),
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductsPage(),
                  ),
                );
              },
            ),
            ListTile(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              leading: const Icon(Icons.settings),
              title: Text(
                getTranslated(context, StringKeys.settings),
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
            ListTile(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              leading: const Icon(CupertinoIcons.square_arrow_left_fill),
              title: Text(
                getTranslated(context, StringKeys.logOut),
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RedirectPage(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      );
}
