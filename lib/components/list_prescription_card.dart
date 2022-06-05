import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_prescription/screens/prescription/prescription_detail_screen.dart';

const double _borderRadius = 16;

class PrescriptionCard extends StatelessWidget {
  const PrescriptionCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, PrescriptionDetail.routeName);
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            _borderRadius,
          ),
          child: SizedBox(
            height: 115,
            width: double.infinity,
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 15,
                    sigmaY: 15,
                  ),
                  child: Container(
                    color: CupertinoColors.activeGreen,
                  ),
                ),
                Container(
                  color: CupertinoColors.white,
                ),
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
                            "Bệnh viện ABC",
                            style: TextStyle(
                              color: CupertinoColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Prescription Date
                          // Row(
                          //   children: [
                          //     Padding(
                          //       padding: EdgeInsets.only(right: 8.0),
                          //       child: Icon(
                          //         Icons.calendar_today,
                          //         color: CupertinoColors.activeGreen,
                          //         size: 16,
                          //       ),
                          //     ),
                          //     const SizedBox(
                          //       width: 5,
                          //     ),
                          //     Text(
                          //       "15/6/2022",
                          //       style: TextStyle(
                          //         color: CupertinoColors.black,
                          //         fontSize: 12,
                          //         fontWeight: FontWeight.w600,
                          //       ),
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Doctor's name
                      Text(
                        "Chẩn đoán 123",
                        style: TextStyle(
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
                            "Tên bác sỹ",
                            style: TextStyle(
                              color: CupertinoColors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          //Followup Date
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: CupertinoColors.activeGreen,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "25/6/2022",
                                style: TextStyle(
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
