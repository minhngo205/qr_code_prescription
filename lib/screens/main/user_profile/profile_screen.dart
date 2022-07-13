import 'package:flutter/material.dart';
import 'package:qr_code_prescription/model/dtos/user_info.dart';

import 'body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key, required this.userInfo}) : super(key: key);

  final UserInfo userInfo;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ProfileBody(
            userInfo: userInfo,
          ),
        ),
      ),
    );
  }
}
