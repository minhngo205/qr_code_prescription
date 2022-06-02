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
  String? _initRoute;
  bool isLoading = true;

  getInitRoute() {
    StorageRepository storageRepository = StorageRepository();
    storageRepository.getRefreshToken().then((value) {
      if (value != null) {
        setState(() {
          _initRoute = MainScreen.routeName;
          isLoading = false;
        });
      } else {
        setState(() {
          _initRoute = LoginScreen.routeName;
          isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    getInitRoute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'QR Code Prescription',
            theme: theme(),
            routes: routes,
            initialRoute: _initRoute,
            // home: _initRoute == MainScreen.routeName ? MainScreen() : LoginScreen(),
          );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'QR Code Prescription',
//       theme: theme(),
//       routes: routes,
//       initialRoute:
//           getInitRoute() != null ? MainScreen.routeName : LoginScreen.routeName,
//     );
//   }

//   String? getInitRoute() {
//     StorageRepository storageRepository = StorageRepository();
//     storageRepository.getRefreshToken().then((value) {
//       debugPrint(value);
//       return value;
//     });
//   }
// }
