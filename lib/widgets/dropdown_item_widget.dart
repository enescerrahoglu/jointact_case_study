import 'package:flutter/material.dart';

class DropdownItemWidget {
  static DropdownMenuItem<int> getDropdownItem(String label, int value) {
    return DropdownMenuItem<int>(
      value: value,
      child: Text(
        label,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
      ),
    );
  }

  static Widget getSelectedDropdownItem(String label) {
    return Container(
      padding: const EdgeInsets.only(left: 15),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        maxLines: 1,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.start,
        style: const TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}
