import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:qr_code_prescription/components/custom_surfix_icon.dart';
import 'package:qr_code_prescription/components/default_button.dart';
import 'package:qr_code_prescription/components/form_error.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'package:qr_code_prescription/utils/size_config.dart';
import 'package:qr_code_prescription/utils/theme/light_color.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  PhoneNumber? phoneNo;
  String? fullName;
  String? password;
  String? confirmPassword;
  final List<String?> errors = [];

  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: const BorderSide(color: kTextColor),
    gapPadding: 10,
  );

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildPhoneNoFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildFullNameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildConfirmPassFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "Đăng ký",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                // Navigator.pushNamed(context, CompleteProfileScreen.routeName);
              }
            },
            backgroundColor: LightColor.lightBlue,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  TextFormField buildConfirmPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => confirmPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == confirmPassword) {
          removeError(error: kMatchPassError);
        }
        confirmPassword = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
        } else if ((password != confirmPassword)) {
          addError(error: kMatchPassError);
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Xác nhận mật khẩu",
        hintText: "Xác nhận lại mật khẩu của bạn",
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

  TextFormField buildFullNameFormField() {
    return TextFormField(
      onSaved: (newValue) => fullName = newValue,
      keyboardType: TextInputType.name,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kFullNameNullError);
        } else if (vnNameRegExp.hasMatch(value)) {
          removeError(error: kInvalidFullName);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNameNullError);
        } else if (!vnNameRegExp.hasMatch(value)) {
          addError(error: kInvalidFullName);
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Họ và tên",
        hintText: "Nhập họ và tên của bạn",
        suffixIcon: const CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
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
}
