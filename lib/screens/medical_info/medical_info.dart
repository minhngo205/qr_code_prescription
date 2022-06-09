import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_prescription/components/card_main.dart';
import 'package:qr_code_prescription/screens/loading/loading_screen.dart';
import 'package:qr_code_prescription/services/dtos/user_info.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';
import 'package:qr_code_prescription/services/user_service/user_service.dart';
import 'package:qr_code_prescription/utils/constants.dart';

import 'task_column.dart';
import 'top_container.dart';

class PersonalScreen extends StatefulWidget {
  static String routeName = "/personal";
  const PersonalScreen({Key? key}) : super(key: key);

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  bool isLoading = true;
  late UserInfo? userInfo;
  loadUserInfo() async {
    StorageRepository _storageRepository = StorageRepository();
    UserRepository _userRepository = UserRepository();
    userInfo = await _storageRepository.getUserInfo();
    if (userInfo == null) {
      debugPrint("Get user info from network");
      userInfo = await _userRepository.getUserInfo();
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Text subheading(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: CupertinoColors.black,
        fontSize: 22.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  @override
  void initState() {
    loadUserInfo();
    super.initState();
  }

  static CircleAvatar calendarIcon() {
    return const CircleAvatar(
      radius: 25.0,
      backgroundColor: CupertinoColors.activeBlue,
      child: Icon(
        Icons.edit,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (isLoading) {
      return Loading(haveText: true);
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: CupertinoColors.activeBlue,
          elevation: 0,
        ),
        backgroundColor: const Color(0xFFFFF9EC),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              TopContainer(
                height: 100,
                width: width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 35.0,
                                backgroundImage: AssetImage(
                                  'assets/icons/user.png',
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    userInfo!.name,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 22.0,
                                      color: CupertinoColors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    userInfo!.user.phoneNumber,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      color: CupertinoColors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.transparent,
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  subheading('Thông tin cá nhân'),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) => CalendarPage()),
                                      // );
                                    },
                                    child: calendarIcon(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              TaskColumn(
                                icon: CupertinoIcons.person,
                                iconBackgroundColor:
                                    CupertinoColors.activeOrange,
                                title: 'Tên',
                                content: userInfo!.name,
                              ),
                              const SizedBox(height: 15.0),
                              TaskColumn(
                                icon: userInfo!.gender
                                    ? Icons.male
                                    : Icons.female,
                                iconBackgroundColor:
                                    CupertinoColors.activeGreen,
                                title: 'Giới tính',
                                content: userInfo!.gender ? 'Nam' : 'Nữ',
                              ),
                              const SizedBox(height: 15.0),
                              TaskColumn(
                                icon: CupertinoIcons.calendar,
                                iconBackgroundColor: CupertinoColors.activeBlue,
                                title: 'Ngày sinh',
                                content: dateformater(userInfo!.dob),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 20),
                              subheading('Chỉ số sức khoẻ'),
                              const SizedBox(height: 20.0),
                              SizedBox(
                                height: 290,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CardMain(
                                          image: const AssetImage(
                                              'assets/icons/high-temperature.png'),
                                          title: "Thân nhiệt",
                                          value: userInfo!
                                              .medicalInfo.bodyTemperature
                                              .toString(),
                                          unit: "°C",
                                          color: CupertinoColors.white,
                                        ),
                                        CardMain(
                                          image: const AssetImage(
                                              'assets/icons/hypertension.png'),
                                          title: "Huyết áp",
                                          value: userInfo!.medicalInfo
                                                  .systolicBloodPressure
                                                  .toString() +
                                              " / " +
                                              userInfo!.medicalInfo
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
                                          value: userInfo!.medicalInfo.height
                                              .toString(),
                                          unit: "cm",
                                          color: CupertinoColors.white,
                                        ),
                                        CardMain(
                                          image: const AssetImage(
                                              'assets/icons/weight.png'),
                                          title: "Cân nặng",
                                          value: userInfo!.medicalInfo.weight
                                              .toString(),
                                          unit: "kg",
                                          color: CupertinoColors.white,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
