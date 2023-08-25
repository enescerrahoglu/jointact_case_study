import 'package:flutter/material.dart';
import 'package:jointact_case_study/constants/color_constants.dart';
import 'package:jointact_case_study/helpers/ui_helper.dart';

class ButtonComponent extends StatefulWidget {
  final String text;
  final Color foregroundColor;
  final Color backgroundColor;
  final bool isWide;
  final bool isLoading;
  final Function()? onPressed;

  const ButtonComponent({
    Key? key,
    required this.text,
    this.foregroundColor = primaryColor,
    this.backgroundColor = buttonBackgroundColor,
    this.isWide = false,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ButtonComponent> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: UIHelper.boxShadow,
      ),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            elevation: 0,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: widget.isWide == true ? const Size.fromHeight(40) : const Size(40, 40),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            shadowColor: Colors.transparent),
        child: Text(
          widget.text,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: widget.foregroundColor),
        ),
      ),
    );
  }
}
