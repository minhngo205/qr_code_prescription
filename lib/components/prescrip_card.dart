import 'package:flutter/material.dart';
import 'package:qr_code_prescription/screens/prescription/prescription_detail_screen.dart';
import 'package:qr_code_prescription/services/dtos/prescription.dart';
import 'package:qr_code_prescription/utils/constants.dart';

class HomePresCard extends StatelessWidget {
  final Prescription prescription;
  final color;
  const HomePresCard({
    Key? key,
    required this.color,
    required this.prescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          PrescriptionDetail.routeName,
          arguments: PresDetailScreenArguments(prescription),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'Đơn thuốc ' + prescription.id.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                prescription.diagnostic,
                maxLines: 2,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    prescription.doctor.hospital.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    dateformater(prescription.createdAt),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
