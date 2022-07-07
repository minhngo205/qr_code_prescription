import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_code_prescription/components/card_items.dart';
import 'package:qr_code_prescription/components/card_main.dart';
import 'package:qr_code_prescription/components/card_section.dart';
import 'package:qr_code_prescription/components/custom_clipper.dart';
import 'package:qr_code_prescription/screens/loading/loading_screen.dart';
import 'package:qr_code_prescription/screens/authen/login/login_screen.dart';
import 'package:qr_code_prescription/screens/qr_code_screen/qr_screen.dart';
import 'package:qr_code_prescription/services/dtos/medicine_list.dart';
import 'package:qr_code_prescription/services/dtos/prescription.dart';
import 'package:qr_code_prescription/services/dtos/user_info.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';
import 'package:qr_code_prescription/services/user_service/user_service.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'package:qr_code_prescription/utils/size_config.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PrescriptionDetail extends StatefulWidget {
  const PrescriptionDetail({Key? key}) : super(key: key);
  static String routeName = "/pres_detail";

  @override
  State<PrescriptionDetail> createState() => _PrescriptionDetailState();
}

class _PrescriptionDetailState extends State<PrescriptionDetail> {
  bool isLoading = true;
  late UserInfo userInfo;
  StorageRepository storageRepository = StorageRepository();

  loadUserInfo() {
    storageRepository.getUserInfo().then((userinfo) => {
          setState(() {
            userInfo = userinfo!;
            isLoading = false;
          })
        });
  }

  @override
  void initState() {
    loadUserInfo();
    super.initState();
  }

  refreshData(int presID) async {
    setState(() {
      isLoading = true;
    });
    UserRepository userRepository = UserRepository();
    var prescription = await userRepository.getPresDetail(presID);
    if (prescription == RequestStatus.RefreshFail) {
      storageRepository.deleteToken();
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    } else if (prescription == RequestStatus.RequestFail) {
      setState(() {
        isLoading = false;
      });

      Alert(
        context: context,
        type: AlertType.error,
        title: "Lỗi",
        desc: "Đã có lỗi xảy ra trong quá trình làm mới, xin hãy thử lại",
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
    } else {
      Navigator.pushReplacementNamed(
        context,
        PrescriptionDetail.routeName,
        arguments: PresDetailScreenArguments(prescription),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as PresDetailScreenArguments;

    getMedicineImage(String usage) {
      if (usage == "Uống") {
        return const AssetImage('assets/icons/capsule.png');
      } else {
        return const AssetImage('assets/icons/syringe.png');
      }
    }

    qrCodeGenerate() async {
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
      UserRepository userRepository = UserRepository();
      var presToken =
          await userRepository.getPresToken(args.prescription.id.toString());
      if (presToken == RequestStatus.RefreshFail) {
        storageRepository.deleteToken();
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.routeName, (route) => false);
      } else if (presToken == RequestStatus.RequestFail) {
        Navigator.of(context).pop();
        Alert(
          context: context,
          type: AlertType.error,
          title: "Lỗi",
          desc: "Đã có lỗi xảy ra trong quá trình tạo mã QR",
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
      } else if (presToken == "This prescription is closed.") {
        Navigator.of(context).pop();
        Alert(
          context: context,
          type: AlertType.error,
          title: "Đơn thuốc đã đóng",
          desc:
              "Đơn thuốc của bạn đã được mua tại hiệu thuốc, hãy tái khám để nhận được đơn thuốc mới nhé",
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
      } else {
        Navigator.of(context).pop();
        Navigator.pushNamed(context, QRCodeScreen.routeName,
            arguments: QRScreenArguments(args.prescription.id, presToken));
      }
    }

    getMedicineStatus(String status) {
      if (status == "open") {
        return false;
      } else {
        return true;
      }
    }

    return isLoading
        ? Loading(haveText: false)
        : Scaffold(
            backgroundColor: Colors.grey[200],
            body: Stack(
              children: <Widget>[
                ClipPath(
                  clipper: MyCustomClipper(clipType: ClipType.bottom),
                  child: Container(
                    color: CupertinoColors.activeGreen,
                    height: 228.5 + SizeConfig.statusBarHeight,
                  ),
                ),
                Positioned(
                  right: -45,
                  top: -30,
                  child: ClipOval(
                    child: Container(
                      color: Colors.black.withOpacity(0.05),
                      height: 220,
                      width: 220,
                    ),
                  ),
                ),

                // BODY
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      refreshData(args.prescription.id);
                    },
                    color: Colors.white,
                    backgroundColor: CupertinoColors.activeBlue,
                    strokeWidth: 5,
                    child: ListView(
                      children: <Widget>[
                        const SizedBox(height: 30),
                        // Header - Greetings and Avatar
                        Row(
                          children: <Widget>[
                            const Expanded(
                              child: Text(
                                "Thông tin đơn thuốc",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white),
                              ),
                            ),
                            GestureDetector(
                              child: CircleAvatar(
                                backgroundColor: Colors.green[600],
                                radius: 26.0,
                                child: const Icon(
                                    CupertinoIcons.qrcode_viewfinder),
                              ),
                              onTap: () {
                                qrCodeGenerate();
                              },
                            )
                          ],
                        ),

                        const SizedBox(height: 50),

                        Material(
                          shadowColor: Colors.grey.withOpacity(0.01), // added
                          type: MaterialType.card,
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            height: 300,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                // Rest Active Legend
                                Text(
                                  args.prescription.doctor.hospital.name
                                      .toString(),
                                  style: const TextStyle(
                                    color: CupertinoColors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Dr. " +
                                          args.prescription.doctor.name
                                              .toString(),
                                      style: const TextStyle(
                                        color: CupertinoColors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Chẩn đoán:",
                                        style: TextStyle(
                                          color: CupertinoColors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        args.prescription.diagnostic.toString(),
                                        style: const TextStyle(
                                          color: CupertinoColors.black,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.justify,
                                        maxLines: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Mã đơn thuốc: ",
                                      style: TextStyle(
                                        color: CupertinoColors.activeGreen,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      args.prescription.id.toString(),
                                      style: const TextStyle(
                                        color: CupertinoColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Expanded(child: SizedBox()),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: Icon(
                                        Icons.calendar_today,
                                        color: CupertinoColors.activeGreen,
                                        size: 16,
                                      ),
                                    ),
                                    Text(
                                      dateformater(args.prescription.createdAt),
                                      style: const TextStyle(
                                        color: CupertinoColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ), // added
                        ),

                        // Section Cards - Daily Medication
                        const SizedBox(height: 50),

                        const Text(
                          "ĐƠN THUỐC",
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          height: 125,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              for (MedicineItem medicineitem
                                  in args.prescription.medicineItems)
                                CardSection(
                                  title: medicineitem.medicine.name,
                                  value: medicineitem.amount.toString(),
                                  unit: "/ liều",
                                  time: medicineitem.medicine.usage +
                                      " " +
                                      medicineitem.medicine.note,
                                  image: getMedicineImage(
                                      medicineitem.medicine.usage),
                                  isDone: getMedicineStatus(
                                      args.prescription.status),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        const Text(
                          "THÔNG TIN BỆNH NHÂN",
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            const Text(
                              "Tên: ",
                              style: TextStyle(
                                color: CupertinoColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              userInfo.name,
                              style: const TextStyle(
                                color: CupertinoColors.black,
                                fontSize: 16,
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            const Text(
                              "Tuổi: ",
                              style: TextStyle(
                                color: CupertinoColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              calculateAge(userInfo.dob).toString(),
                              style: const TextStyle(
                                color: CupertinoColors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Main Cards - Heartbeat and Blood Pressure
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
                                    value: userInfo.medicalInfo.bodyTemperature
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
                                        userInfo
                                            .medicalInfo.diastolicBloodPressure
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
                                    value:
                                        userInfo.medicalInfo.height.toString(),
                                    unit: "cm",
                                    color: CupertinoColors.white,
                                  ),
                                  CardMain(
                                    image: const AssetImage(
                                        'assets/icons/weight.png'),
                                    title: "Cân nặng",
                                    value:
                                        userInfo.medicalInfo.weight.toString(),
                                    unit: "kg",
                                    color: CupertinoColors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        // Scheduled Activities
                        const Text(
                          "TIỀN SỬ BỆNH",
                          style: TextStyle(
                              color: kTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 20),

                        ListView(
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: <Widget>[
                            userInfo.medicalInfo.medicalHistory.isEmpty ||
                                    userInfo.medicalInfo.medicalHistory ==
                                        "None"
                                ? CardItems(
                                    image:
                                        Image.asset('assets/icons/cancel.png'),
                                    title: "Chưa có tiền sử bệnh",
                                    color: kPrimaryColor,
                                  )
                                : CardItems(
                                    image:
                                        Image.asset('assets/icons/checked.png'),
                                    title: userInfo.medicalInfo.medicalHistory,
                                    color: CupertinoColors.activeGreen,
                                  )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}

class PresDetailScreenArguments {
  final Prescription prescription;
  PresDetailScreenArguments(this.prescription);
}
