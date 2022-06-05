import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_prescription/components/card_items.dart';
import 'package:qr_code_prescription/components/card_main.dart';
import 'package:qr_code_prescription/components/card_section.dart';
import 'package:qr_code_prescription/components/custom_clipper.dart';
import 'package:qr_code_prescription/screens/splash/splash_screen.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'package:qr_code_prescription/utils/size_config.dart';

class PrescriptionDetail extends StatelessWidget {
  const PrescriptionDetail({Key? key}) : super(key: key);
  static String routeName = "/pres";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        child: const Icon(CupertinoIcons.qrcode_viewfinder),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, SplashPage.routeName);
                      },
                    )
                  ],
                ),

                const SizedBox(height: 50),

                Material(
                  shadowColor: Colors.grey.withOpacity(0.01), // added
                  type: MaterialType.card,
                  elevation: 10, borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    height: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        // Rest Active Legend
                        const Text(
                          "Bệnh viện Quân Y 199",
                          style: TextStyle(
                            color: CupertinoColors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "Dr. Vũ Như Thành",
                          style: TextStyle(
                            color: CupertinoColors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Chẩn đoán:",
                                style: TextStyle(
                                  color: CupertinoColors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Bệnh đái tháo đường không phụ thuộc insuline (Chưa có biến chứng) / Rối loạn chuyển hoá lipoprotein và tình trạng lipit máu khác",
                                style: TextStyle(
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
                          children: const [
                            Text(
                              "Mã đơn thuốc: ",
                              style: TextStyle(
                                color: CupertinoColors.activeGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "1234",
                              style: TextStyle(
                                color: CupertinoColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: Icon(
                                Icons.calendar_today,
                                color: CupertinoColors.activeGreen,
                                size: 16,
                              ),
                            ),
                            Text(
                              "22/5/2022",
                              style: TextStyle(
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
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  height: 125,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const <Widget>[
                      CardSection(
                        image: AssetImage('assets/icons/capsule.png'),
                        title: "Metforminv",
                        value: "2",
                        unit: "viên",
                        time: "2 lần",
                        isDone: false,
                      ),
                      CardSection(
                        image: AssetImage('assets/icons/syringe.png'),
                        title: "Trulicity",
                        value: "1",
                        unit: "liều",
                        time: "1 lần",
                        isDone: true,
                      )
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
                  children: const [
                    Text(
                      "Tên: ",
                      style: TextStyle(
                        color: CupertinoColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Nguyễn Văn Á",
                      style: TextStyle(
                        color: CupertinoColors.black,
                        fontSize: 16,
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      "Tuổi: ",
                      style: TextStyle(
                        color: CupertinoColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "24 tuổi",
                      style: TextStyle(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          CardMain(
                            image:
                                AssetImage('assets/icons/high-temperature.png'),
                            title: "Thân nhiệt",
                            value: "27",
                            unit: "°C",
                            color: CupertinoColors.white,
                          ),
                          CardMain(
                            image: AssetImage('assets/icons/hypertension.png'),
                            title: "Huyết áp",
                            value: "66/123",
                            unit: "mmHg",
                            color: CupertinoColors.white,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          CardMain(
                            image: AssetImage('assets/icons/height.png'),
                            title: "Chiều cao",
                            value: "170",
                            unit: "cm",
                            color: CupertinoColors.white,
                          ),
                          CardMain(
                            image: AssetImage('assets/icons/weight.png'),
                            title: "Cân nặng",
                            value: "70",
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
                    CardItems(
                      image: Image.asset('assets/icons/cancel.png'),
                      title: "Chưa có tiền sử bệnh",
                      color: kPrimaryColor,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
