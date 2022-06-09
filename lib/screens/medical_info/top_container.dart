import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TopContainer extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final EdgeInsets? padding;
  const TopContainer({
    Key? key,
    required this.height,
    required this.width,
    required this.child,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: const BoxDecoration(
          color: CupertinoColors.activeBlue,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
          )),
      height: height,
      width: width,
      child: child,
    );
  }
}
