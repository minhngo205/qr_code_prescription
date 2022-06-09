import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
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
  bool _isObscure = true;

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
            backgroundColor: CupertinoColors.activeBlue,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget buildPhoneNoFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: IntlPhoneField(
        disableLengthCheck: true,
        pickerDialogStyle: PickerDialogStyle(
          searchFieldInputDecoration: InputDecoration(
            hintText: "Chọn quốc gia",
            enabledBorder: outlineInputBorder,
            focusedBorder: outlineInputBorderFocus,
            fillColor: Colors.grey[200],
            filled: true,
          ),
        ),
        // controller: TextEditingController(text: phoneNo!.number),
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
          hintText: "Số điện thoại",
          suffixIcon: const Icon(CupertinoIcons.phone),
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorderFocus,
          errorBorder: outlineInputBorderFocus,
          fillColor: Colors.grey[200],
          filled: true,
        ),
        initialCountryCode: "VN",
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }

  Widget buildPasswordFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
        // controller: TextEditingController(text: password!),
        obscureText: _isObscure,
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
          hintText: "Mật khẩu",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
            icon: _isObscure
                ? const Icon(CupertinoIcons.eye)
                : const Icon(CupertinoIcons.eye_slash_fill),
          ),
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorderFocus,
          errorBorder: outlineInputBorderFocus,
          fillColor: Colors.grey[200],
          filled: true,
        ),
        style: const TextStyle(fontSize: 18.0),
      ),
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
