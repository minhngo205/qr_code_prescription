import 'package:flutter/material.dart';
import 'package:qr_code_prescription/utils/size_config.dart';

import 'components/body.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";

  const OtpScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as OTPScreenArguments;

    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Body(
        argument: args,
      ),
    );
  }
}

class OTPScreenArguments {
  final String phoneNumber;
  final String password;
  final String fullName;
  OTPScreenArguments(this.phoneNumber, this.password, this.fullName);
}
