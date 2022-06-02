import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'package:qr_code_prescription/utils/theme/light_color.dart';
import 'package:qr_code_prescription/utils/theme/text_styles.dart';
import 'package:qr_code_prescription/utils/theme/extention.dart';

class SplashPage extends StatefulWidget {
  static String routeName = "/splash";
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2)).then((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlueLightColor,
      body: SafeArea(
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 1),
          ),
          margin: const EdgeInsets.all(30),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Mã sức khoẻ",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 200,
                child: PrettyQr(
                  data: "https://www.facebook.com/hoangminh.ngo.205",
                  image: const AssetImage('assets/icons/app_icon.png'),
                  typeNumber: 3,
                  size: 200,
                  errorCorrectLevel: QrErrorCorrectLevel.M,
                  roundEdges: true,
                ),
              ),
              const Text(
                "Bệnh nhân: Nguyễn Văn A",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
