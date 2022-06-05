import 'package:flutter/material.dart';
import 'package:qr_code_prescription/screens/prescription/prescription_detail_screen.dart';

class PresCard extends StatelessWidget {
  final int presId;
  final String diagnostic;
  final String hospital;
  final String createDate;
  final color;
  const PresCard({
    Key? key,
    required this.presId,
    required this.diagnostic,
    required this.hospital,
    required this.createDate,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, PrescriptionDetail.routeName);
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
                'Đơn thuốc $presId',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                diagnostic,
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
                    hospital,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    createDate,
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
