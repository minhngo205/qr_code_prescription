import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:qr_code_prescription/components/default_button.dart';
import 'package:qr_code_prescription/components/form_error.dart';
import 'package:qr_code_prescription/screens/authen/otp/otp_screen.dart';
import 'package:qr_code_prescription/services/authentication/authentication_service.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'package:qr_code_prescription/utils/size_config.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  late final AuthenticationRepository authRepository;
  PhoneNumber? phoneNo;
  String? fullName;
  String? password;
  String? confirmPassword;
  final List<String?> errors = [];

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

  bool _isObscure = true;
  bool _isObscureConfirm = true;

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
  void initState() {
    authRepository = AuthenticationRepository();
    super.initState();
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
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(40)),
          DefaultButton(
            text: "????ng k??",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // if all are valid then go to success screen
                onRegisterPress(context);
              }
            },
            backgroundColor: CupertinoColors.activeBlue,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget buildConfirmPassFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
        obscureText: _isObscureConfirm,
        onSaved: (newValue) => confirmPassword = newValue,
        onChanged: (value) {
          if (value.isNotEmpty) {
            removeError(error: kPassNullError);
          }
          if (password == confirmPassword) {
            removeError(error: kMatchPassError);
          }
          confirmPassword = value;
        },
        validator: (value) {
          if (value!.isEmpty) {
            addError(error: kPassNullError);
          } else {
            removeError(error: kPassNullError);
          }
          if (password != confirmPassword) {
            addError(error: kMatchPassError);
          } else {
            removeError(error: kMatchPassError);
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "X??c nh???n m???t kh???u",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isObscureConfirm = !_isObscureConfirm;
              });
            },
            icon: _isObscureConfirm
                ? const Icon(CupertinoIcons.eye_slash_fill)
                : const Icon(CupertinoIcons.eye),
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
          } else {
            removeError(error: kPassNullError);
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "M???t kh???u",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
            icon: _isObscure
                ? const Icon(CupertinoIcons.eye_slash_fill)
                : const Icon(CupertinoIcons.eye),
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

  Widget buildPhoneNoFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: IntlPhoneField(
        disableLengthCheck: true,
        pickerDialogStyle: PickerDialogStyle(
          searchFieldInputDecoration: InputDecoration(
            hintText: "Ch???n qu???c gia",
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
          } else {
            removeError(error: kPhoneNoNullError);
          }
          if (!phoneNoValidatorRegExp.hasMatch(value.completeNumber)) {
            addError(error: kInvalidPhoneNoError);
          } else {
            removeError(error: kInvalidPhoneNoError);
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "S??? ??i???n tho???i",
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

  Widget buildFullNameFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
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
          } else {
            removeError(error: kFullNameNullError);
          }
          if (!vnNameRegExp.hasMatch(value)) {
            // addError(error: kInvalidFullName);
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Nh???p h??? v?? t??n c???a b???n",
          suffixIcon: const Icon(CupertinoIcons.person),
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorderFocus,
          fillColor: Colors.grey[200],
          filled: true,
        ),
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }

  void onRegisterPress(BuildContext context) async {
    String registerResponse =
        await authRepository.requestOTP(phoneNo!.completeNumber);
    // register(
    //     phoneNo!.completeNumber, password!, fullName!, "OTP123");
    if (registerResponse != "Success") {
      showTopSnackBar(
        context,
        CustomSnackBar.error(message: registerResponse),
      );
    } else {
      clearError();
      showTopSnackBar(
        context,
        const CustomSnackBar.success(message: "???? ????ng k?? th??nh c??ng"),
      );
      Navigator.pushNamed(
        context,
        OtpScreen.routeName,
        arguments: OTPScreenArguments(
          phoneNo!.completeNumber,
          password!,
          fullName!,
        ),
      );
    }
  }

  void clearError() {
    setState(() {
      errors.clear();
    });
  }
}
