import 'package:flutter/widgets.dart';
import 'package:qr_code_prescription/screens/edit_screen/change_password.dart';
import 'package:qr_code_prescription/screens/edit_screen/edit_info.dart';
import 'package:qr_code_prescription/screens/errors/connection_lost.dart';
import 'package:qr_code_prescription/screens/list_screen/detail_hospital_drugstore/hospital_drugstore_detail.dart';
import 'package:qr_code_prescription/screens/authen/login/login_screen.dart';
import 'package:qr_code_prescription/screens/main/main_screen.dart';
import 'package:qr_code_prescription/screens/list_screen/list_screen.dart';
import 'package:qr_code_prescription/screens/medical_info/user_info.dart';
import 'package:qr_code_prescription/screens/prescription/prescription_detail_screen.dart';
import 'package:qr_code_prescription/screens/authen/register/register_screen.dart';
import 'package:qr_code_prescription/screens/qr_code_screen/qr_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => const LoginScreen(),
  MainScreen.routeName: (context) => const MainScreen(),
  QRCodeScreen.routeName: (context) => const QRCodeScreen(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  PrescriptionDetail.routeName: (context) => const PrescriptionDetail(),
  ConnectionFaildScreen.routeName: (context) => const ConnectionFaildScreen(),
  // PersonalScreen.routeName: (context) => const PersonalScreen(),
  ListScreen.routeName: (context) => const ListScreen(),
  UserInfoPage.routeName: (context) => const UserInfoPage(),
  HospitalDrugstoreDetail.routeName: (context) =>
      const HospitalDrugstoreDetail(),
  EditInfoScreen.routeName: (context) => const EditInfoScreen(),
  ChangePassword.routeName: (context) => const ChangePassword(),
};
