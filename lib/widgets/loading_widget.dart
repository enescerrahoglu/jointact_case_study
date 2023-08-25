import 'package:flutter/material.dart';
import 'package:jointact_case_study/constants/color_constants.dart';

class LoadingWidget extends StatefulWidget {
  final bool isLoading;
  const LoadingWidget({super.key, required this.isLoading});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isLoading,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black54,
        child: const Center(
            child: CircularProgressIndicator(
          color: secondaryColor,
          backgroundColor: primaryColor,
        )),
      ),
    );
  }
}
