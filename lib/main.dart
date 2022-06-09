import 'package:flutter/material.dart';
import 'package:qr_code_prescription/screens/loading/loading_screen.dart';
import 'package:qr_code_prescription/screens/login/login_screen.dart';
import 'package:qr_code_prescription/screens/main/main_screen.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';
import 'package:qr_code_prescription/utils/route.dart';
import 'package:qr_code_prescription/utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QRCodeApp());
}

class QRCodeApp extends StatefulWidget {
  const QRCodeApp({Key? key}) : super(key: key);

  @override
  State<QRCodeApp> createState() => _QRCodeAppState();
}

class _QRCodeAppState extends State<QRCodeApp> {
  String _initRoute = LoginScreen.routeName;
  bool isLoading = true;

  getInitRoute() async {
    StorageRepository storageRepository = StorageRepository();
    String? refreshToken = await storageRepository.getRefreshToken();
    if (refreshToken == null) {
      setState(() {
        _initRoute = LoginScreen.routeName;
        isLoading = false;
      });
    } else {
      setState(() {
        _initRoute = MainScreen.routeName;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getInitRoute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading(haveText: false)
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'QR Code Prescription',
            theme: theme(),
            routes: routes,
            initialRoute: _initRoute,
          );
  }
}
