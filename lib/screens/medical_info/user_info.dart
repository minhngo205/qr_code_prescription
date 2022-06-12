import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_prescription/components/card_main.dart';
import 'package:qr_code_prescription/screens/edit_screen/edit_info.dart';
import 'package:qr_code_prescription/screens/errors/connection_lost.dart';
import 'package:qr_code_prescription/screens/loading/loading_screen.dart';
import 'package:qr_code_prescription/screens/medical_info/task_column.dart';
import 'package:qr_code_prescription/services/dtos/user_info.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';
import 'package:qr_code_prescription/services/user_service/user_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../utils/constants.dart';

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);
  static String routeName = "/personal";

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  late UserInfo userInfo;
  bool isLoading = true;
  final StorageRepository _storageRepository = StorageRepository();
  final UserRepository _userRepository = UserRepository();

  loadUserInfo() async {
    UserInfo? userInfoFromStorage = await _storageRepository.getUserInfo();
    if (userInfoFromStorage != null) {
      setState(() {
        userInfo = userInfoFromStorage!;
        isLoading = false;
      });
    } else {
      debugPrint("Get user info from network");
      userInfoFromStorage = await _userRepository.getUserInfo();
      if (userInfoFromStorage != null) {
        setState(() {
          userInfo = userInfoFromStorage!;
          isLoading = false;
        });
      } else {
        Navigator.pushReplacementNamed(
            context, ConnectionFaildScreen.routeName);
      }
    }
  }

  refreshData() async {
    setState(() {
      isLoading = true;
    });

    UserInfo? userInfoNetwork = await _userRepository.getUserInfo();
    if (userInfoNetwork != null) {
      await _storageRepository.saveUserInfo(userInfoNetwork);
      setState(() {
        userInfo = userInfoNetwork;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      Alert(
        context: context,
        type: AlertType.error,
        title: "Lỗi !!!",
        desc: "Đã có lỗi xảy ra khi làm mới thông tin",
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

  @override
  void initState() {
    loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading(haveText: false)
        : RefreshIndicator(
            onRefresh: () => refreshData(),
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        //color: Color(0xFFD4E7FE),
                        gradient: LinearGradient(
                            colors: [
                              Color(0xFFD4E7FE),
                              Color(0xFFF0F0F0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.6, 0.3])),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 50),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: RichText(
                            text: TextSpan(
                                text: dateformater(DateTime.now()) + " ",
                                style: const TextStyle(
                                    color: Color(0XFF263064),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900),
                                children: [
                                  TextSpan(
                                    text: DateFormat('hh:mm')
                                        .format(DateTime.now()),
                                    style: const TextStyle(
                                        color: Color(0XFF263064),
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal),
                                  )
                                ]),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(width: 1, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blueGrey.withOpacity(0.2),
                                    blurRadius: 12,
                                    spreadRadius: 8,
                                  )
                                ],
                                image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/icons/user.png"),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userInfo.name,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0XFF343E87),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  userInfo.user.phoneNumber,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text(
                                  "Đây là thông tin y tế của bạn",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 185,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      height: MediaQuery.of(context).size.height - 240,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: ListView(
                        children: [
                          buildTitleRow("THÔNG TIN CÁ NHÂN", true),
                          const SizedBox(height: 20),
                          TaskColumn(
                            icon: CupertinoIcons.number,
                            iconBackgroundColor: CupertinoColors.systemIndigo,
                            title: 'Mã ID',
                            content: userInfo.id.toString(),
                          ),
                          const SizedBox(height: 20),
                          TaskColumn(
                            icon: CupertinoIcons.person,
                            iconBackgroundColor: CupertinoColors.activeOrange,
                            title: 'Tên',
                            content: userInfo.name,
                          ),
                          const SizedBox(height: 15.0),
                          TaskColumn(
                            icon: userInfo.gender ? Icons.male : Icons.female,
                            iconBackgroundColor: CupertinoColors.activeGreen,
                            title: 'Giới tính',
                            content: userInfo.gender ? 'Nam' : 'Nữ',
                          ),
                          const SizedBox(height: 15.0),
                          TaskColumn(
                            icon: CupertinoIcons.calendar,
                            iconBackgroundColor: CupertinoColors.activeBlue,
                            title: 'Ngày sinh',
                            content: dateformater(userInfo.dob),
                          ),
                          const SizedBox(height: 15.0),
                          TaskColumn(
                            icon: Icons.card_membership,
                            iconBackgroundColor: CupertinoColors.systemYellow,
                            title: 'CMND/CCCD',
                            content: userInfo.identifyNumber,
                          ),
                          const SizedBox(height: 15.0),
                          TaskColumn(
                            icon: CupertinoIcons.creditcard,
                            iconBackgroundColor: CupertinoColors.link,
                            title: 'Bảo hiểm xã hội',
                            content: userInfo.socialInsurance,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          buildTitleRow("THÔNG TIN SỨC KHOẺ", false),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 290,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CardMain(
                                      image: const AssetImage(
                                          'assets/icons/high-temperature.png'),
                                      title: "Thân nhiệt",
                                      value: userInfo
                                          .medicalInfo.bodyTemperature
                                          .toString(),
                                      unit: "°C",
                                      color: CupertinoColors.white,
                                    ),
                                    CardMain(
                                      image: const AssetImage(
                                          'assets/icons/hypertension.png'),
                                      title: "Huyết áp",
                                      value: userInfo
                                              .medicalInfo.systolicBloodPressure
                                              .toString() +
                                          " / " +
                                          userInfo.medicalInfo
                                              .diastolicBloodPressure
                                              .toString(),
                                      unit: "mmHg",
                                      color: CupertinoColors.white,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CardMain(
                                      image: const AssetImage(
                                          'assets/icons/height.png'),
                                      title: "Chiều cao",
                                      value: userInfo.medicalInfo.height
                                          .toString(),
                                      unit: "cm",
                                      color: CupertinoColors.white,
                                    ),
                                    CardMain(
                                      image: const AssetImage(
                                          'assets/icons/weight.png'),
                                      title: "Cân nặng",
                                      value: userInfo.medicalInfo.weight
                                          .toString(),
                                      unit: "kg",
                                      color: CupertinoColors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // SingleChildScrollView(
                          //   scrollDirection: Axis.horizontal,
                          //   child: Row(
                          //     children: [
                          //       buildTaskItem(
                          //           3, "The Basic of Typography II", Colors.red),
                          //       buildTaskItem(3, "Design Psychology: Principle of...",
                          //           Colors.green),
                          //       buildTaskItem(3, "Design Psychology: Principle of...",
                          //           Colors.green),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Row buildTitleRow(String title, bool isEditable) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
              text: title,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
              children: const [
                TextSpan(
                  text: "",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.normal),
                ),
              ]),
        ),
        isEditable
            ? GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, EditInfoScreen.routeName)
                      .then((_) {
                    setState(() {
                      loadUserInfo();
                    });
                  });
                },
                child: const Text(
                  "Chỉnh sửa",
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0XFF3E3993),
                      fontWeight: FontWeight.bold),
                ),
              )
            : const SizedBox(width: 0)
      ],
    );
  }
}
