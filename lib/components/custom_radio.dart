import 'package:flutter/material.dart';
import 'package:qr_code_prescription/model/gender.dart';

class CustomRadio extends StatelessWidget {
  final Gender _gender;

  const CustomRadio(this._gender, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _gender.isSelected ? const Color(0xFF3B4257) : Colors.white,
      child: Container(
        height: 80,
        width: 80,
        alignment: Alignment.center,
        margin: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              _gender.icon,
              color: _gender.isSelected ? Colors.white : Colors.grey,
              size: 40,
            ),
            const SizedBox(height: 10),
            Text(
              _gender.name,
              style: TextStyle(
                  color: _gender.isSelected ? Colors.white : Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
