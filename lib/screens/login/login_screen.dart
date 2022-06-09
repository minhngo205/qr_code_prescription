import 'package:flutter/material.dart';
import 'package:qr_code_prescription/screens/login/login_body.dart';
import 'package:qr_code_prescription/utils/size_config.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String routeName = "/log_in";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: const Body(),
    );
  }
}
