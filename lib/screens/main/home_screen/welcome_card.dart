import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_prescription/utils/constants.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Đơn thuốc gần đây',
                style: kTitleStyle,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 200,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: CupertinoColors.activeBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                //image
                Container(
                  height: 100,
                  width: 100,
                  color: Colors.transparent,
                  child: Image.asset("assets/images/medical-team.png"),
                ),
                const SizedBox(width: 20),
                //how do you feel
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Bạn chưa có đơn thuốc nào',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: CupertinoColors.white,
                        ),
                      ),
                      const Text(
                        'Hãy kiểm tra sức khỏe của bạn ngay nhé',
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          print("Tab");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              'Khám phá ngay',
                              style: TextStyle(
                                color: CupertinoColors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
