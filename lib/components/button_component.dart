import 'package:flutter/material.dart';

class ButtonComponent extends StatefulWidget {
  final String text;
  final bool isWide;
  final double topPadding;
  final double bottomPadding;
  final double rightPadding;
  final double leftPadding;
  final double textPadding;
  final bool isLoading;
  final Function()? onPressed;

  const ButtonComponent({
    Key? key,
    required this.text,
    this.isWide = false,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.rightPadding = 0,
    this.leftPadding = 0,
    this.textPadding = 12,
    this.isLoading = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<ButtonComponent> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.topPadding, bottom: widget.bottomPadding, right: widget.rightPadding, left: widget.leftPadding),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: OutlinedButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 0,
          minimumSize: widget.isWide == true ? const Size.fromHeight(10) : const Size(10, 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Padding(
          padding: EdgeInsets.all(widget.textPadding),
          child: widget.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                )
              : SizedBox(
                  height: 26,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      widget.text,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
