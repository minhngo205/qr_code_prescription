import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_code_prescription/components/default_button.dart';
import 'package:qr_code_prescription/screens/authen/otp/otp_screen.dart';
import 'package:qr_code_prescription/screens/main/main_screen.dart';
import 'package:qr_code_prescription/services/authentication/authentication_service.dart';
import 'package:qr_code_prescription/utils/size_config.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  final OTPScreenArguments arguments;

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  AuthenticationRepository authRepository = AuthenticationRepository();

  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  String pin1 = "";
  String pin2 = "";
  String pin3 = "";
  String pin4 = "";

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  autofocus: true,
                  onSaved: (value) => pin1 = value!,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    pin1 = value;
                    nextField(value, pin2FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  focusNode: pin2FocusNode,
                  onSaved: (value) => pin2 = value!,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    pin2 = value;
                    nextField(value, pin3FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  focusNode: pin3FocusNode,
                  onSaved: (value) => pin3 = value!,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    pin3 = value;
                    nextField(value, pin4FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: getProportionateScreenWidth(60),
                child: TextFormField(
                  focusNode: pin4FocusNode,
                  onSaved: (value) => pin4 = value!,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(1),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    pin4 = value;
                    if (value.length == 1) {
                      pin4FocusNode!.unfocus();
                      // Then you need to check is the code is correct or not
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          DefaultButton(
            text: "Xác nhận",
            backgroundColor: CupertinoColors.activeBlue,
            textColor: Colors.white,
            press: () {
              debugPrint("$pin1$pin2$pin3$pin4");
              if (pin1.isNotEmpty &&
                  pin2.isNotEmpty &&
                  pin3.isNotEmpty &&
                  pin4.isNotEmpty) {
                onOTPConfirm();
              }
            },
          )
        ],
      ),
    );
  }

  void onOTPConfirm() async {
    String registerResponse = await authRepository.register(
      widget.arguments.phoneNumber,
      widget.arguments.password,
      widget.arguments.fullName,
      "$pin1$pin2$pin3$pin4",
    );
    if (registerResponse != "Success") {
      showTopSnackBar(
        context,
        CustomSnackBar.error(message: registerResponse),
      );
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.success(
            message:
                "Chào mừng: ${widget.arguments.fullName} đã đến với hệ thống"),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainScreen.routeName,
        (route) => false,
      );
    }
  }
}

final otpInputDecoration = InputDecoration(
    contentPadding:
        EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorderFocus,
    errorBorder: outlineInputBorderFocus,
    fillColor: Colors.grey[200],
    filled: true,
    hintText: "0");

OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: const BorderSide(color: CupertinoColors.white),
  gapPadding: 10,
);

OutlineInputBorder outlineInputBorderFocus = OutlineInputBorder(
  borderRadius: BorderRadius.circular(12),
  borderSide: const BorderSide(color: CupertinoColors.activeBlue),
  gapPadding: 10,
);
