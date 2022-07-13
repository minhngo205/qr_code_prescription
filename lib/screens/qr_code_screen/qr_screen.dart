import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRCodeScreen extends StatefulWidget {
  static String routeName = "/prescription_qr";
  const QRCodeScreen({Key? key}) : super(key: key);

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as QRScreenArguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CupertinoColors.activeBlue,
        centerTitle: true,
        title: const Text('Mã QR đơn thuốc'),
      ),
      backgroundColor: CupertinoColors.lightBackgroundGray,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/gradient-image.png"),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Chia sẻ mã QR để được tư vấn về sức khoẻ\nHệ thống mã QR đơn thuốc điện tử",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CupertinoColors.black,
                  fontSize: 16,
                ),
              ),
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  // boxShadow: const [
                  //   BoxShadow(
                  //     color: CupertinoColors.activeBlue,
                  //     blurRadius: 4,
                  //     offset: Offset(4, 8), // Shadow position
                  //   ),
                  // ],
                ),
                child: Center(
                  child: SizedBox(
                    height: 250,
                    child: PrettyQr(
                      data: args.data,
                      image: const AssetImage('assets/icons/app_icon.png'),
                      typeNumber: 9,
                      size: 250,
                      errorCorrectLevel: QrErrorCorrectLevel.M,
                      roundEdges: true,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    args.fullName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: CupertinoColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "ID đơn thuốc: ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CupertinoColors.black,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        args.id.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: CupertinoColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ImageButton(
                      imagePath: 'assets/icons/cloud-computing.png',
                      btnText: 'Lưu\nmã QR',
                    ),
                    ImageButton(
                      imagePath: 'assets/icons/qr.png',
                      btnText: 'Quét\nmã QR',
                    ),
                    ImageButton(
                      imagePath: 'assets/icons/share.png',
                      btnText: 'Chia sẻ\nmã QR',
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImageButton extends StatelessWidget {
  final Function()? btnTapped;
  final String imagePath;
  final String btnText;

  const ImageButton(
      {Key? key,
      this.btnTapped,
      required this.imagePath,
      required this.btnText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: btnTapped,
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Center(
              child: Image.asset(imagePath),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            btnText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class QRScreenArguments {
  final int id;
  final String data;
  final String fullName;
  QRScreenArguments(this.id, this.data, this.fullName);
}
