import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      width: 70,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: const [
          CircleAvatar(
            backgroundImage: AssetImage("assets/icons/user.png"),
            radius: 30.0,
            backgroundColor: Colors.transparent,
          ),
          Positioned(
            right: -4,
            bottom: -5,
            height: 25,
            width: 25,
            child: Icon(CupertinoIcons.camera_circle),
          )
        ],
      ),
    );
  }
}
