import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_prescription/screens/loading/loading_screen.dart';
import 'package:qr_code_prescription/services/dtos/hospital_drugstore.dart';
import 'package:qr_code_prescription/services/public_service/public_service.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HospitalDrugstoreDetail extends StatefulWidget {
  const HospitalDrugstoreDetail({Key? key}) : super(key: key);
  static String routeName = "/hospital_drugstore/detail";

  @override
  State<HospitalDrugstoreDetail> createState() =>
      _HospitalDrugstoreDetailState();
}

class _HospitalDrugstoreDetailState extends State<HospitalDrugstoreDetail> {
  final _controller = PageController();
  bool isLoading = false;

  refreshData(int detailID, String role) async {
    setState(() {
      isLoading = true;
    });

    PublicService publicService = PublicService();
    HospitalDrugstore? detail =
        await publicService.getDetailHospital(role + "s", detailID);

    if (detail != null) {
      Navigator.pushReplacementNamed(
        context,
        HospitalDrugstoreDetail.routeName,
        arguments: HospitalDrugstoreDetailArguments(detail),
      );
    } else {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as HospitalDrugstoreDetailArguments;

    Size size = MediaQuery.of(context).size;
    return isLoading
        ? Loading(haveText: true)
        : RefreshIndicator(
            onRefresh: () async {},
            child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                leading: const Icon(Icons.arrow_back_ios_outlined,
                    color: Colors.black, size: 18.0),
                title: args.detail.user.role == "hospital"
                    ? const Text(
                        'Thông tin Bệnh viện',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        'Thông tin Nhà thuốc',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: size.width,
                        height: 400,
                        child: PageView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            args.detail.user.role == "hospital"
                                ? Image.asset(
                                    "assets/images/hospital.png",
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.scaleDown,
                                  )
                                : Image.asset(
                                    "assets/images/pharmacy.png",
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.scaleDown,
                                  )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Center(
                        child: SmoothPageIndicator(
                          controller: _controller,
                          count: 1,
                          effect: const ExpandingDotsEffect(
                            activeDotColor: CupertinoColors.activeBlue,
                            dotColor: CupertinoColors.inactiveGray,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          'Mã số: ${args.detail.id}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              args.detail.name,
                              style: const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            // const Text('\$120',
                            //     style: TextStyle(
                            //         fontSize: 25.0,
                            //         color: Colors.black,
                            //         fontFamily: 'Montserrat-black')),
                          ],
                        ),
                      ),
                      // const SizedBox(height: 30.0),
                      // Container(
                      //   margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      //   child: const Text('Sizes',
                      //       style: const TextStyle(
                      //           fontSize: 15.0,
                      //           fontWeight: FontWeight.w600,
                      //           color: Colors.black)),
                      // ),
                      // const SizedBox(height: 20.0),
                      // SingleChildScrollView(
                      //   scrollDirection: Axis.horizontal,
                      //   child: Row(
                      //     children: [
                      //       const SizedBox(width: 10.0),
                      //       _makeSizeButton('US7', true),
                      //       const SizedBox(width: 8.0),
                      //       _makeSizeButton('US7.5', true),
                      //       const SizedBox(width: 8.0),
                      //       _makeSizeButton('US8', false),
                      //       const SizedBox(width: 8.0),
                      //       _makeSizeButton('US8.5', true),
                      //       const SizedBox(width: 8.0),
                      //       _makeSizeButton('US9', true),
                      //       const SizedBox(width: 8.0),
                      //       _makeSizeButton('US9.5', true),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(height: 20.0),
                      // Container(
                      //   margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      //   child: const Text('*Faster Shipping options may be available',
                      //       style: const TextStyle(fontSize: 13.0, color: Colors.grey)),
                      // ),
                      const SizedBox(height: 30.0),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: const Text('Địa chỉ',
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                      ),
                      const SizedBox(height: 15.0),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          args.detail.address,
                          style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _makeSizeButton(String size, bool available) {
    return Container(
      width: 80.0,
      height: 30.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(const Radius.circular(30.0)),
        border: available
            ? Border.all(color: Colors.grey, width: 0.3)
            : Border.all(color: Colors.transparent, width: 0),
        color: available ? Colors.white : Colors.grey[300],
      ),
      child: Center(
        child: Text(size,
            style: available
                ? const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)
                : TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[50])),
      ),
    );
  }
}

class HospitalDrugstoreDetailArguments {
  final HospitalDrugstore detail;
  HospitalDrugstoreDetailArguments(this.detail);
}
