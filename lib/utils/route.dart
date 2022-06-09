import 'package:flutter/widgets.dart';
import 'package:qr_code_prescription/screens/errors/connection_lost.dart';
import 'package:qr_code_prescription/screens/login/login_screen.dart';
import 'package:qr_code_prescription/screens/main/main_screen.dart';
import 'package:qr_code_prescription/screens/medical_info/medical_info.dart';
import 'package:qr_code_prescription/screens/prescription/personal_list_prescription.dart';
import 'package:qr_code_prescription/screens/prescription/prescription_detail_screen.dart';
import 'package:qr_code_prescription/screens/register/register_screen.dart';
import 'package:qr_code_prescription/screens/qr_code_screen/qr_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => const LoginScreen(),
  MainScreen.routeName: (context) => const MainScreen(),
  QRCodeScreen.routeName: (context) => const QRCodeScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  PrescriptionDetail.routeName: (context) => const PrescriptionDetail(),
  ListPresScreen.routeName: (context) => const ListPresScreen(),
  ConnectionFaildScreen.routeName: (context) => const ConnectionFaildScreen(),
  PersonalScreen.routeName: (context) => const PersonalScreen(),
};
