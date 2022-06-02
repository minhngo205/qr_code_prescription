import 'package:flutter/material.dart';
import 'package:qr_code_prescription/screens/register/register_screen.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'package:qr_code_prescription/utils/size_config.dart';
import 'package:qr_code_prescription/utils/theme/light_color.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Bạn chưa có tài khoản? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(16)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, RegisterScreen.routeName),
          child: Text(
            "Đăng ký ngay",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(16),
                color: LightColor.skyBlue),
          ),
        ),
      ],
    );
  }
}
