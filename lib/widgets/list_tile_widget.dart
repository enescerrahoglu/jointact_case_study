import 'package:flutter/material.dart';
import 'package:jointact_case_study/constants/color_constants.dart';

/// Bu sınıf kişiselleştirilmiş bir ListTile widgetı sunar.
class ListTileWidget extends StatelessWidget {
  final IconData? iconData;
  final String content;
  final Function()? onTap;
  const ListTileWidget({super.key, required this.content, this.iconData, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      shadowColor: Colors.grey.withOpacity(0.5),
      elevation: 10,
      child: ListTile(
        onTap: onTap,
        title: Text(
          content,
          style: const TextStyle(
            fontSize: 16,
          ),
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.fade,
        ),
        leading: iconData != null
            ? Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Icon(
                  iconData!,
                  color: secondaryColor,
                ),
              )
            : const SizedBox(),
        trailing: onTap == null
            ? null
            : const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
              ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide.none,
        ),
        tileColor: itemBackgroundColor,
      ),
    );
  }
}
