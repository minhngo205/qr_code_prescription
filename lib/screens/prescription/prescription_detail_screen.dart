import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_code_prescription/components/card_items.dart';
import 'package:qr_code_prescription/components/card_main.dart';
import 'package:qr_code_prescription/components/card_section.dart';
import 'package:qr_code_prescription/components/custom_clipper.dart';
import 'package:qr_code_prescription/screens/list_screen/detail_hospital_drugstore/hospital_drugstore_detail.dart';
import 'package:qr_code_prescription/screens/loading/loading_screen.dart';
import 'package:qr_code_prescription/screens/authen/login/login_screen.dart';
import 'package:qr_code_prescription/screens/qr_code_screen/qr_screen.dart';
import 'package:qr_code_prescription/model/dtos/medicine_item.dart';
import 'package:qr_code_prescription/model/dtos/prescription.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';
import 'package:qr_code_prescription/services/user_service/user_service.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'package:qr_code_prescription/utils/size_config.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PrescriptionDetail extends StatefulWidget {
  const PrescriptionDetail({Key? key, required this.prescriptionID})
      : super(key: key);
  static String routeName = "/pres_detail";
  final int prescriptionID;

  @override
  State<PrescriptionDetail> createState() => _PrescriptionDetailState();
}

class _PrescriptionDetailState extends State<PrescriptionDetail> {
  bool isLoading = true;
  StorageRepository storageRepository = StorageRepository();
  UserRepository userRepository = UserRepository();
  late Prescription prescription;

  @override
  void initState() {
    getData(widget.prescriptionID);
    super.initState();
  }

  getData(int presID) async {
    setState(() {
      isLoading = true;
    });
    var response = await userRepository.getPresDetail(presID);
    if (response == RequestStatus.RefreshFail) {
      storageRepository.deleteToken();
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    } else if (response == RequestStatus.RequestFail) {
      setState(() {
        isLoading = false;
      });

      Navigator.pop(context);

      Alert(
        context: context,
        type: AlertType.error,
        title: "L???i",
        desc: "???? c?? l???i x???y ra trong qu?? tr??nh l???y th??ng tin, xin h??y th??? l???i",
        buttons: [
          DialogButton(
            child: const Text(
              "Hu???",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: CupertinoColors.activeBlue,
          ),
        ],
      ).show();
    } else {
      setState(() {
        prescription = response;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getMedicineImage(String usage) {
      if (usage == "U???ng") {
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
                        "??ang t???i ...",
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
      var presToken =
          await userRepository.getPresToken(widget.prescriptionID.toString());
      if (presToken == RequestStatus.RefreshFail) {
        storageRepository.deleteToken();
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.routeName, (route) => false);
      } else if (presToken == RequestStatus.RequestFail) {
        Navigator.of(context).pop();
        Alert(
          context: context,
          type: AlertType.error,
          title: "L???i",
          desc: "???? c?? l???i x???y ra trong qu?? tr??nh t???o m?? QR",
          buttons: [
            DialogButton(
              child: const Text(
                "Hu???",
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
          title: "????n thu???c ???? ????ng",
          desc:
              "????n thu???c c???a b???n ???? ???????c mua t???i hi???u thu???c, h??y t??i kh??m ????? nh???n ???????c ????n thu???c m???i nh??",
          buttons: [
            DialogButton(
              child: const Text(
                "Hu???",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: CupertinoColors.activeBlue,
            ),
          ],
        ).show();
      } else {
        Navigator.of(context).pop();
        Navigator.pushNamed(
          context,
          QRCodeScreen.routeName,
          arguments: QRScreenArguments(
            widget.prescriptionID,
            presToken,
            prescription.patient.name,
          ),
        );
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
                      getData(prescription.id);
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
                                "Th??ng tin ????n thu???c",
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
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      HospitalDrugstoreDetail.routeName,
                                      arguments:
                                          HospitalDrugstoreDetailArguments(
                                              prescription.doctor.hospital),
                                    );
                                  },
                                  child: Text(
                                    prescription.doctor.hospital.name,
                                    style: const TextStyle(
                                      color: CupertinoColors.black,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                prescription.doctor.avatar),
                                            fit: BoxFit.cover),
                                        border: Border.all(
                                          color: prescription
                                                  .doctor.user.isActive
                                              ? CupertinoColors.activeGreen
                                              : CupertinoColors.destructiveRed,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Dr. " + prescription.doctor.name,
                                            style: const TextStyle(
                                              color: CupertinoColors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            prescription.doctor.department,
                                            // style: TextStyle(
                                            //     color: this.isSelected!
                                            //         ? Colors.white
                                            //         : AppColors.MAIN_COLOR),
                                          ),
                                        ],
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
                                        "Ch???n ??o??n:",
                                        style: TextStyle(
                                          color: CupertinoColors.black,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        prescription.diagnostic.toString(),
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
                                      "M?? ????n thu???c: ",
                                      style: TextStyle(
                                        color: CupertinoColors.activeGreen,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      prescription.id.toString(),
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
                                      dateformater(prescription.createdAt),
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
                          "????N THU???C",
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
                          height: 220,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              for (MedicineItem medicineitem
                                  in prescription.medicineItems)
                                CardSection(
                                  title: medicineitem.medicine.name,
                                  value: medicineitem.medicine.tradeName,
                                  unit: medicineitem.medicine.concentration,
                                  time: medicineitem.medicine.usage == "U???ng"
                                      ? "${medicineitem.amount} vi??n"
                                      : "${medicineitem.amount} li???u",
                                  image: getMedicineImage(
                                      medicineitem.medicine.usage),
                                  isDone:
                                      getMedicineStatus(prescription.status),
                                  instruction: medicineitem.doctorNote,
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        const Text(
                          "TH??NG TIN B???NH NH??N",
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "T??n: ",
                                  style: TextStyle(
                                    color: CupertinoColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  prescription.patient.name,
                                  style: const TextStyle(
                                    color: CupertinoColors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                const Text(
                                  "Tu???i: ",
                                  style: TextStyle(
                                    color: CupertinoColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  calculateAge(prescription.patient.dob)
                                      .toString(),
                                  style: const TextStyle(
                                    color: CupertinoColors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  "Gi???i t??nh: ",
                                  style: TextStyle(
                                    color: CupertinoColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  prescription.patient.gender ? "Nam" : "N???",
                                  style: const TextStyle(
                                    color: CupertinoColors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                                const Text(
                                  "Nh??m m??u: ",
                                  style: TextStyle(
                                    color: CupertinoColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  prescription.medicalInfo.bloodGroup,
                                  style: const TextStyle(
                                    color: CupertinoColors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  "Ti???n s??? b???nh: ",
                                  style: TextStyle(
                                    color: CupertinoColors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  prescription.patient.medicalInfo
                                          .medicalHistory.isEmpty
                                      ? "Ch??a c?? ti???n s??? b???nh"
                                      : prescription
                                          .patient.medicalInfo.medicalHistory,
                                  style: const TextStyle(
                                    color: CupertinoColors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
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
                                    title: "Th??n nhi???t",
                                    value: prescription
                                        .medicalInfo.bodyTemperature
                                        .toString(),
                                    unit: "??C",
                                    color: CupertinoColors.white,
                                  ),
                                  CardMain(
                                    image: const AssetImage(
                                        'assets/icons/hypertension.png'),
                                    title: "Huy???t ??p",
                                    value: prescription
                                            .medicalInfo.systolicBloodPressure
                                            .toString() +
                                        " / " +
                                        prescription
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
                                    title: "Chi???u cao",
                                    value: prescription.medicalInfo.height
                                        .toString(),
                                    unit: "cm",
                                    color: CupertinoColors.white,
                                  ),
                                  CardMain(
                                    image: const AssetImage(
                                        'assets/icons/weight.png'),
                                    title: "C??n n???ng",
                                    value: prescription.medicalInfo.weight
                                        .toString(),
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
                        ListView(
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: <Widget>[
                            const Text(
                              "D???N D?? C???A B??C S???",
                              style: TextStyle(
                                  color: kTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            prescription.doctorNote.isEmpty
                                ? CardItems(
                                    image:
                                        Image.asset('assets/icons/cancel.png'),
                                    title: "B??c s??? kh??ng c?? d???n d?? g?? th??m",
                                    color: kPrimaryColor,
                                  )
                                : CardItems(
                                    image:
                                        Image.asset('assets/icons/checked.png'),
                                    title: prescription.doctorNote,
                                    color: CupertinoColors.activeGreen,
                                  ),
                            const SizedBox(height: 20),
                            Visibility(
                              visible: prescription.status == "closed",
                              child: const Text(
                                "D???N D?? C???A D?????C S???",
                                style: TextStyle(
                                    color: kTextColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 20),
                            prescription.pharmacistNote.isEmpty
                                ? Visibility(
                                    visible: prescription.status == "closed",
                                    child: CardItems(
                                      image: Image.asset(
                                          'assets/icons/cancel.png'),
                                      title: "D?????c s??? kh??ng c?? d???n d?? g?? th??m",
                                      color: kPrimaryColor,
                                    ),
                                  )
                                : Visibility(
                                    visible: prescription.status == "closed",
                                    child: CardItems(
                                      image: Image.asset(
                                          'assets/icons/checked.png'),
                                      title: prescription.pharmacistNote,
                                      color: CupertinoColors.activeGreen,
                                    ),
                                  ),
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
  final int prescriptionId;
  PresDetailScreenArguments(this.prescriptionId);
}

// showDialog(
// barrierDismissible: false,
// context: context,
// builder: (_) {
// return Dialog(
// insetPadding: const EdgeInsets.symmetric(horizontal: 140),
// elevation: 10,
// backgroundColor: Colors.transparent,
// child: Container(
// width: 100.0,
// height: 100.0,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(12),
// color: CupertinoColors.activeBlue,
// ),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// const SpinKitPouringHourGlassRefined(
// color: CupertinoColors.white,
// ),
// Column(
// children: const [
// SizedBox(height: 10),
// Text(
// "??ang t???i ...",
// style: TextStyle(color: CupertinoColors.white),
// ),
// ],
// )
// ],
// ),
// ),
// );
// },
// );