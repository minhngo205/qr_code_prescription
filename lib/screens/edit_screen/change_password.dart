import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_code_prescription/components/default_button.dart';
import 'package:qr_code_prescription/services/user_service/api.dart';
import 'package:qr_code_prescription/services/user_service/user_service.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'package:qr_code_prescription/utils/keyboard.dart';
import 'package:qr_code_prescription/utils/size_config.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);
  static String routeName = "/change_pass";

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isObscure1 = true;
  bool _isObscure2 = true;

  String? currentPass;
  String? newPass;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CupertinoColors.activeBlue,
        title: const Text("Đổi mật khẩu"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mật khẩu hiện tại',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      SizedBox(height: getProportionateScreenHeight(15)),
                      buildPasswordFormField(),
                      SizedBox(height: getProportionateScreenHeight(15)),
                      const Text(
                        'Mật khẩu cập nhật',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      SizedBox(height: getProportionateScreenHeight(15)),
                      buildChagePassFromField(),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      DefaultButton(
                        text: "Đổi mật khẩu",
                        press: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            // if all are valid then go to success screen
                            KeyboardUtil.hideKeyboard(context);
                            changePassword();
                            // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                          }
                        },
                        backgroundColor: CupertinoColors.activeBlue,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  Widget buildPasswordFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
        // controller: TextEditingController(text: password!),
        obscureText: _isObscure1,
        onSaved: (newValue) => currentPass = newValue,
        onChanged: (value) {
          // if (value.isNotEmpty) {
          //   removeError(error: kPassNullError);
          // } else if (value.length >= 8) {
          //   removeError(error: kShortPassError);
          // }
          // return;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return kPassNullError;
          } /* else if (value.length < 8) {
              addError(error: kShortPassError);
              return "";
            } */
          return null;
        },
        decoration: InputDecoration(
          hintText: "Mật khẩu",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isObscure1 = !_isObscure1;
              });
            },
            icon: _isObscure1
                ? const Icon(CupertinoIcons.eye)
                : const Icon(CupertinoIcons.eye_slash_fill),
          ),
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorderFocus,
          errorBorder: outlineInputBorderFocus,
          focusedErrorBorder: outlineInputBorderFocus,
          fillColor: Colors.grey[200],
          filled: true,
        ),
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }

  buildChagePassFromField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
        // controller: TextEditingController(text: password!),
        obscureText: _isObscure2,
        onSaved: (newValue) => newPass = newValue,
        onChanged: (value) {
          // if (value.isNotEmpty) {
          //   removeError(error: kPassNullError);
          // } else if (value.length >= 8) {
          //   removeError(error: kShortPassError);
          // }
          // return;
        },
        validator: (value) {
          if (value!.isEmpty) {
            return kPassNullError;
          } /* else if (value.length < 8) {
              addError(error: kShortPassError);
              return "";
            } */
          return null;
        },
        decoration: InputDecoration(
          hintText: "Mật khẩu mới",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isObscure2 = !_isObscure2;
              });
            },
            icon: _isObscure2
                ? const Icon(CupertinoIcons.eye)
                : const Icon(CupertinoIcons.eye_slash_fill),
          ),
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorderFocus,
          errorBorder: outlineInputBorderFocus,
          focusedErrorBorder: outlineInputBorderFocus,
          fillColor: Colors.grey[200],
          filled: true,
        ),
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }

  void changePassword() async {
    if (currentPass != newPass) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 140),
            elevation: 10,
            backgroundColor: Colors.transparent,
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: CupertinoColors.activeBlue,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SpinKitPouringHourGlassRefined(
                    color: CupertinoColors.white,
                  ),
                  Column(
                    children: const [
                      SizedBox(height: 10),
                      Text(
                        "Đang tải ...",
                        style: TextStyle(color: CupertinoColors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );

      Api api = Api();
      bool isSuccess = await api.changePassword(currentPass!, newPass!);

      Navigator.pop(context);
      if (isSuccess) {
        Alert(
          context: context,
          type: AlertType.success,
          title: "Thành công",
          desc: "Cập nhật thông tin thành công",
          buttons: [
            DialogButton(
              child: const Text(
                "Xác nhận",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: CupertinoColors.activeBlue,
            ),
          ],
        ).show();
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Lỗi",
          desc: "Đã có lỗi xảy ra trong quá trình đổi mật khẩu",
          buttons: [
            DialogButton(
              child: const Text(
                "Huỷ",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: CupertinoColors.activeBlue,
            ),
          ],
        ).show();
      }
    } else {
      Alert(
        context: context,
        type: AlertType.warning,
        title: "Lỗi",
        desc: "Mật khẩu mới phải khác với mật khẩu cũ",
        buttons: [
          DialogButton(
            child: const Text(
              "Huỷ",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: CupertinoColors.activeBlue,
          ),
        ],
      ).show();
    }
  }
}
