import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:qr_code_prescription/components/custom_surfix_icon.dart';
import 'package:qr_code_prescription/components/default_button.dart';
import 'package:qr_code_prescription/components/form_error.dart';
import 'package:qr_code_prescription/screens/main/main_screen.dart';
import 'package:qr_code_prescription/services/authentication/authentication_service.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'package:qr_code_prescription/utils/keyboard.dart';
import 'package:qr_code_prescription/utils/size_config.dart';
import 'package:qr_code_prescription/utils/theme/light_color.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final AuthenticationRepository authRepository;
  final _formKey = GlobalKey<FormState>();
  PhoneNumber? phoneNo;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];

  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(color: kTextColor),
    gapPadding: 10,
  );

  @override
  void initState() {
    authRepository = AuthenticationRepository();
    super.initState();
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void clearError() {
    setState(() {
      errors.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildPhoneNoFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: LightColor.lightBlue,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                // onTap: () => Navigator.pushNamed(context, ForgotPasswordScreen.routeName),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Đăng nhập",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                KeyboardUtil.hideKeyboard(context);
                onLoginPress(context);
                // Navigator.pushNamed(context, LoginSuccessScreen.routeName);
              }
            },
            backgroundColor: LightColor.lightBlue,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  IntlPhoneField buildPhoneNoFormField() {
    return IntlPhoneField(
      onSaved: (newValue) => phoneNo = newValue,
      keyboardType: TextInputType.phone,
      onChanged: (value) {
        if (value.number.isNotEmpty) {
          removeError(error: kPhoneNoNullError);
        } else if (phoneNoValidatorRegExp.hasMatch(value.completeNumber)) {
          debugPrint("Valid");
          removeError(error: kInvalidPhoneNoError);
        }
        return;
      },
      validator: (value) {
        if (value!.number.isEmpty) {
          addError(error: kPhoneNoNullError);
        } else if (!phoneNoValidatorRegExp.hasMatch(value.completeNumber)) {
          addError(error: kInvalidPhoneNoError);
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Số điện thoại",
        hintText: "Nhập số điện thoại của bạn",
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Call.svg"),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        border: outlineInputBorder,
        fillColor: kSecondaryColor,
      ),
      initialCountryCode: "VN",
      style: const TextStyle(fontSize: 18.0),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
        } /* else if (value.length < 8) {
            addError(error: kShortPassError);
            return "";
          } */
        return null;
      },
      decoration: InputDecoration(
        labelText: "Mật khẩu",
        hintText: "Nhập mật khẩu của bạn",
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        border: outlineInputBorder,
        fillColor: kSecondaryColor,
      ),
      style: const TextStyle(fontSize: 18.0),
    );
  }

  void onLoginPress(BuildContext context) async {
    debugPrint(phoneNo!.completeNumber);
    String loginResponse =
        await authRepository.login(phoneNo!.completeNumber, password!);
    if (loginResponse != "Success") {
      showTopSnackBar(
        context,
        CustomSnackBar.error(message: loginResponse),
      );
    } else {
      clearError();
      showTopSnackBar(
        context,
        const CustomSnackBar.success(message: "Đăng nhập thành công"),
      );
      Navigator.pushReplacementNamed(context, MainScreen.routeName);
    }
  }
}
