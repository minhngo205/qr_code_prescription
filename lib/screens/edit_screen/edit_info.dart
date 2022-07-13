import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:qr_code_prescription/components/custom_radio.dart';
import 'package:qr_code_prescription/components/default_button.dart';
import 'package:qr_code_prescription/model/gender.dart';
import 'package:qr_code_prescription/screens/errors/connection_lost.dart';
import 'package:qr_code_prescription/screens/loading/loading_screen.dart';
import 'package:qr_code_prescription/screens/authen/login/login_screen.dart';
import 'package:qr_code_prescription/model/dtos/user_info.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';
import 'package:qr_code_prescription/services/user_service/user_service.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'package:qr_code_prescription/utils/keyboard.dart';
import 'package:qr_code_prescription/utils/size_config.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditInfoScreen extends StatefulWidget {
  const EditInfoScreen({Key? key}) : super(key: key);
  static String routeName = "/update_info";

  @override
  State<EditInfoScreen> createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends State<EditInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Gender> genders = <Gender>[
    Gender("Nam", Icons.male, false),
    Gender("Nữ", Icons.female, false)
  ];
  StorageRepository storageRepository = StorageRepository();
  UserRepository userRepository = UserRepository();
  bool isLoading = true;

  late var firstNameValue;
  late var firstGender;
  late var firstDOB;
  late var firstID;
  late var firstSocial;

  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _IDController = TextEditingController();
  // final TextEditingController _socialController = TextEditingController();

  late UserInfo userInfo;

  initFirstValue(UserInfo userInfo) {
    firstNameValue = userInfo.name;
    firstGender = userInfo.gender;
    firstDOB = userInfo.dob;
    firstID = userInfo.identifyNumber;
    firstSocial = userInfo.socialInsurance;
    userInfo.gender
        ? genders[0].isSelected = true
        : genders[1].isSelected = true;
  }

  bool isDataChanged() {
    return firstNameValue != userInfo.name ||
        firstGender != userInfo.gender ||
        firstDOB != userInfo.dob ||
        firstID != userInfo.identifyNumber ||
        firstSocial != userInfo.socialInsurance;
  }

  loadData() async {
    UserInfo? userFromStorage = await storageRepository.getUserInfo();
    if (userFromStorage != null) {
      debugPrint("Get user from storage");
      setState(() {
        userInfo = userFromStorage;
        initFirstValue(userInfo);
        isLoading = false;
      });
    } else {
      var userFromAPI = await userRepository.getUserInfo();
      if (userFromAPI == RequestStatus.RefreshFail) {
        storageRepository.deleteToken();
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.routeName, (route) => false);
      } else if (userFromAPI == RequestStatus.RequestFail) {
        debugPrint("Error");
        Navigator.pushReplacementNamed(
          context,
          ConnectionFaildScreen.routeName,
        );
      } else {
        debugPrint("Get user from API");
        setState(() {
          userInfo = userFromAPI;
          initFirstValue(userInfo);
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading(haveText: false)
        : Scaffold(
            appBar: AppBar(
              backgroundColor: CupertinoColors.activeBlue,
              title: const Text("Cập nhật"),
              centerTitle: true,
            ),
            body: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.screenHeight * 0.04),
                      Text("Thay đổi thông tin", style: headingStyle),
                      const Text(
                        "Hãy đảm bảo thông tin\nbạn cung cấp là chính xác",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.04),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Họ và tên',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            buildFullNameFormField(),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            const Text(
                              'Giới tính',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            buildGenderForm(),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            const Text(
                              'Ngày sinh',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            buidDOBFormField(),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            const Text(
                              'CMND/CCCD',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            bulidIDFormField(),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            const Text(
                              'Bảo hiểm xã hội',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            bulidSocialFormField(),
                            SizedBox(height: getProportionateScreenHeight(30)),
                            //                   FormError(errors: errors),
                            // SizedBox(height: getProportionateScreenHeight(40)),
                            DefaultButton(
                              text: "Cập nhật",
                              press: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  // if all are valid then go to success screen
                                  KeyboardUtil.hideKeyboard(context);
                                  if (isDataChanged()) {
                                    Alert(
                                      context: context,
                                      type: AlertType.info,
                                      title: "Xác nhận",
                                      desc:
                                          "Bạn đã kiểm tra kỹ và muốn cập nhật thông tin",
                                      buttons: [
                                        DialogButton(
                                          child: const Text(
                                            "Huỷ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color: CupertinoColors.destructiveRed,
                                        ),
                                        DialogButton(
                                          child: const Text(
                                            "Xác nhận",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            updateInfo();
                                          },
                                          color: CupertinoColors.activeBlue,
                                        ),
                                      ],
                                    ).show();
                                  } else {
                                    Alert(
                                      context: context,
                                      type: AlertType.warning,
                                      title: "Lỗi",
                                      desc: "Bạn chưa thay đổi thông tin gì cả",
                                      buttons: [
                                        DialogButton(
                                          child: const Text(
                                            "Huỷ",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          color: CupertinoColors.activeBlue,
                                        ),
                                      ],
                                    ).show();
                                  }
                                }
                              },
                              backgroundColor: CupertinoColors.activeBlue,
                              textColor: Colors.white,
                            ),
                            SizedBox(height: getProportionateScreenHeight(30)),
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

  Widget buildFullNameFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
        initialValue: userInfo.name,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        onSaved: (name) {
          setState(() {
            userInfo.name = name!;
          });
        },
        validator: (value) {
          if (value!.isEmpty) {
            return kNameNullError;
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Họ và tên",
          suffixIcon: const Icon(CupertinoIcons.person),
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorderFocus,
          errorBorder: outlineInputBorder,
          focusedErrorBorder: outlineInputBorderFocus,
          fillColor: Colors.grey[200],
          filled: true,
        ),
        style: const TextStyle(fontSize: 18.0),
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

  Widget buildGenderForm() {
    return Center(
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: genders.length,
          itemBuilder: (context, index) {
            return InkWell(
              splashColor: Colors.white,
              onTap: () {
                setState(() {
                  for (var gender in genders) {
                    gender.isSelected = false;
                  }
                  genders[index].isSelected = true;
                  userInfo.gender = genders[0].isSelected;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: CustomRadio(genders[index]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buidDOBFormField() {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: () {
          DatePicker.showDatePicker(
            context,
            showTitleActions: true,
            minTime: DateTime(1900, 1, 1),
            maxTime: DateTime.now(),
            onChanged: (date) {
              print('change $date');
            },
            onConfirm: (date) {
              setState(() {
                userInfo.dob = date;
              });
            },
            currentTime: userInfo.dob,
            locale: LocaleType.vi,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            dateformater(userInfo.dob),
            style: const TextStyle(
              fontSize: 18,
              color: CupertinoColors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget bulidIDFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
        initialValue: userInfo.identifyNumber,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onSaved: (idcard) {
          setState(() {
            userInfo.identifyNumber = idcard!;
          });
        },
        validator: (value) {
          if (value!.isEmpty) {
            return "Trường này không được để trống";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "CMND/CCCD",
          suffixIcon: const Icon(Icons.card_membership),
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorderFocus,
          errorBorder: outlineInputBorder,
          focusedErrorBorder: outlineInputBorderFocus,
          fillColor: Colors.grey[200],
          filled: true,
        ),
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }

  bulidSocialFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: TextFormField(
        initialValue: userInfo.socialInsurance,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onSaved: (social) {
          setState(() {
            userInfo.socialInsurance = social!;
          });
        },
        validator: (value) {
          if (value!.isEmpty) {
            return "Trường này không được để trống";
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "Bảo hiểm xã hội",
          suffixIcon: const Icon(CupertinoIcons.creditcard),
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorderFocus,
          errorBorder: outlineInputBorder,
          focusedErrorBorder: outlineInputBorderFocus,
          fillColor: Colors.grey[200],
          filled: true,
        ),
        style: const TextStyle(fontSize: 18.0),
      ),
    );
  }

  void updateInfo() async {
    // debugPrint(userInfo.toJson().toString());
    setState(() {
      isLoading = true;
    });
    var updatedInfo = await userRepository.updateUserInfo(userInfo);
    if (updatedInfo == RequestStatus.RefreshFail) {
      storageRepository.deleteToken();
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    } else if (updatedInfo == RequestStatus.RequestFail) {
      setState(() {
        isLoading = false;
      });

      Alert(
        context: context,
        type: AlertType.error,
        title: "Lỗi",
        desc: "Đã có lỗi xảy ra trong quá trình cập nhật thông tin",
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
    } else if (updatedInfo != null) {
      await storageRepository.saveUserInfo(updatedInfo);
      setState(() {
        userInfo = updatedInfo;
        initFirstValue(userInfo);
        isLoading = false;
      });
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
    }
  }
}
