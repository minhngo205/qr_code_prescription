import 'package:flutter/material.dart';
import 'package:qr_code_prescription/screens/prescription/prescription_detail_screen.dart';
import 'package:qr_code_prescription/utils/constants.dart';

import '../model/dtos/prescription_item.dart';

class HomePresCard extends StatelessWidget {
  final PrescriptionItem prescriptionItem;
  // ignore: prefer_typing_uninitialized_variables
  final color;
  const HomePresCard({
    Key? key,
    required this.color,
    required this.prescriptionItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PrescriptionDetail(prescriptionID: prescriptionItem.id)));
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
                'Đơn thuốc ${prescriptionItem.id}',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                prescriptionItem.diagnostic,
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
                    prescriptionItem.doctor.hospital.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    dateformater(prescriptionItem.createdAt),
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
