import 'package:flutter/material.dart';
import 'package:qr_code_prescription/screens/register/register_body.dart';

class RegisterScreen extends StatelessWidget {
  static String routeName = "/register";
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: const Body(),
    );
  }
}
