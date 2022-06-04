import 'package:flutter/widgets.dart';
import 'package:qr_code_prescription/screens/login/login_screen.dart';
import 'package:qr_code_prescription/screens/main/main_screen.dart';
import 'package:qr_code_prescription/screens/prescription/prescription_screen.dart';
import 'package:qr_code_prescription/screens/register/register_screen.dart';
import 'package:qr_code_prescription/screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => const LoginScreen(),
  MainScreen.routeName: (context) => const MainScreen(),
  SplashPage.routeName: (context) => const SplashPage(),
  RegisterScreen.routeName: (context) => const RegisterScreen(),
  PrescriptionScreen.routeName: (context) => const PrescriptionScreen(),
};
