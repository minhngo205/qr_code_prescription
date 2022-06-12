import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_prescription/screens/edit_screen/change_password.dart';
import 'package:qr_code_prescription/screens/login/login_screen.dart';
import 'package:qr_code_prescription/screens/medical_info/user_info.dart';
import 'package:qr_code_prescription/services/dtos/user_info.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'profile_menu.dart';
import 'profile_pic.dart';

class ProfileBody extends StatelessWidget {
  final UserInfo userInfo;

  const ProfileBody({Key? key, required this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logOut() {
      StorageRepository storageRepository = StorageRepository();
      storageRepository.deleteToken();
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Row(
              children: [
                const ProfilePic(),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userInfo.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(
                      userInfo.user.phoneNumber,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ProfileMenu(
            text: "Thông tin cá nhân",
            icon: CupertinoIcons.person_fill,
            press: () => {
              Navigator.pushNamed(context, UserInfoPage.routeName),
            },
          ),
          ProfileMenu(
            text: "Thông báo",
            icon: CupertinoIcons.bell_fill,
            press: () {},
          ),
          ProfileMenu(
            text: "Đổi mật khẩu",
            icon: CupertinoIcons.settings_solid,
            press: () {
              Navigator.pushNamed(context, ChangePassword.routeName);
            },
          ),
          ProfileMenu(
            text: "Trợ giúp",
            icon: CupertinoIcons.question_circle_fill,
            press: () {},
          ),
          ProfileMenu(
            text: "Đăng xuất",
            icon: CupertinoIcons.lock_fill,
            press: () {
              Alert(
                context: context,
                type: AlertType.warning,
                title: "Bạn đang đăng xuất",
                desc: "Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng ?",
                buttons: [
                  DialogButton(
                    child: const Text(
                      "Huỷ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                    color: CupertinoColors.activeBlue,
                  ),
                  DialogButton(
                    child: const Text(
                      "Đăng xuất",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () => logOut(),
                    color: CupertinoColors.destructiveRed,
                  ),
                ],
              ).show();
            },
          ),
        ],
      ),
    );
  }
}
