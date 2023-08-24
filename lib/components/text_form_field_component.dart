import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldComponent extends StatefulWidget {
  final BuildContext context;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final Widget? iconData;
  final String? prefixText;
  final String? hintText;
  final bool readOnly;
  final bool enabled;
  final bool enableSuggestions;
  final bool autocorrect;
  final bool autofocus;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;
  final double topPadding;
  final double bottomPadding;
  final double rightPadding;
  final double leftPadding;
  final Color? itemBackgroundColor;
  final bool isPassword;
  final TextInputAction textInputAction;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final Function()? onTap;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxCharacter;
  final Widget? suffixIcon;
  final bool numbersOnly;

  const TextFormFieldComponent({
    Key? key,
    required this.context,
    required this.textEditingController,
    this.keyboardType = TextInputType.text,
    this.iconData,
    this.hintText,
    this.readOnly = false,
    this.enabled = true,
    this.enableSuggestions = true,
    this.autocorrect = true,
    this.autofocus = false,
    this.textAlign = TextAlign.start,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.rightPadding = 0,
    this.leftPadding = 0,
    this.itemBackgroundColor,
    this.isPassword = false,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.onChanged,
    this.onTap,
    this.focusNode,
    this.maxLines = 1,
    this.maxCharacter = 10000,
    this.prefixText,
    this.suffixIcon,
    this.numbersOnly = false,
  }) : super(key: key);

  @override
  State<TextFormFieldComponent> createState() => _TextFormFieldComponentState();
}

class _TextFormFieldComponentState extends State<TextFormFieldComponent> {
  bool isObscured = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.topPadding, bottom: widget.bottomPadding, right: widget.rightPadding, left: widget.leftPadding),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: TextFormField(
          textAlignVertical: TextAlignVertical.top,
          textAlign: widget.textAlign,
          expands: widget.maxLines == null ? true : false,
          minLines: null,
          maxLines: widget.maxLines,
          enableSuggestions: widget.enableSuggestions,
          autocorrect: widget.autocorrect,
          autofocus: widget.autofocus,
          style: const TextStyle(
            color: Colors.black,
          ),
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          focusNode: widget.focusNode,
          validator: widget.validator,
          controller: widget.textEditingController,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          inputFormatters: [
            LengthLimitingTextInputFormatter(widget.maxCharacter),
            (widget.numbersOnly == true
                ? FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                : LengthLimitingTextInputFormatter(widget.maxCharacter)),
            (widget.numbersOnly == true
                ? FilteringTextInputFormatter.digitsOnly
                : LengthLimitingTextInputFormatter(widget.maxCharacter)),
          ],
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.deepPurple.shade300),
            errorStyle: const TextStyle(height: 0),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(15),
            errorMaxLines: 3,
            prefixIcon: widget.iconData != null
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: widget.iconData!,
                  )
                : widget.prefixText != null
                    ? Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        child: Text(
                          widget.prefixText!,
                          style: const TextStyle(color: Colors.deepPurple, fontSize: 12),
                        ),
                      )
                    : null,
            hintText: widget.hintText,
            fillColor: widget.itemBackgroundColor ?? Colors.white,
            filled: true,
            suffixIcon: widget.suffixIcon ??
                (widget.isPassword == true
                    ? InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10, top: 15, bottom: 15),
                          child: Icon(
                            isObscured ? Icons.visibility : Icons.visibility_off,
                            color: Colors.deepPurple,
                          ),
                        ),
                      )
                    : null),
          ),
          cursorColor: Colors.deepPurple,
          scrollPadding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          obscureText: widget.isPassword
              ? isObscured
                  ? true
                  : false
              : false,
        ),
      ),
    );
  }
}
