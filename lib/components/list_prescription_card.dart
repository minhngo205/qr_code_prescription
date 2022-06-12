import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_prescription/screens/prescription/prescription_detail_screen.dart';
import 'package:qr_code_prescription/services/dtos/prescription.dart';
import 'package:qr_code_prescription/utils/constants.dart';

const double _borderRadius = 12;

class PrescriptionCard extends StatelessWidget {
  final Prescription prescription;

  const PrescriptionCard({
    Key? key,
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
      child: Card(
        elevation: 5.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            _borderRadius,
          ),
          child: SizedBox(
            height: 115,
            width: double.infinity,
            child: Stack(
              children: [
                // Content
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Hospital name
                          Text(
                            "Đơn thuốc: ${prescription.id}",
                            style: const TextStyle(
                              color: CupertinoColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Prescription Date
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: prescription.status == 'open'
                                    ? const Icon(
                                        CupertinoIcons.checkmark,
                                        color: CupertinoColors.activeGreen,
                                        size: 16,
                                      )
                                    : const Icon(
                                        CupertinoIcons.clear,
                                        color: CupertinoColors.destructiveRed,
                                        size: 16,
                                      ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              prescription.status == 'open'
                                  ? const Text(
                                      "Mới",
                                      style: TextStyle(
                                        color: CupertinoColors.activeGreen,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : const Text(
                                      "Đã mua",
                                      style: TextStyle(
                                        color: CupertinoColors.destructiveRed,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Doctor's name
                      Text(
                        prescription.doctor.hospital.name,
                        maxLines: 2,
                        style: const TextStyle(
                          color: CupertinoColors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // patient name
                          Text(
                            prescription.doctor.name,
                            style: const TextStyle(
                              color: CupertinoColors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          //Followup Date
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: CupertinoColors.activeBlue,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                dateformater(prescription.createdAt),
                                style: const TextStyle(
                                  color: CupertinoColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
