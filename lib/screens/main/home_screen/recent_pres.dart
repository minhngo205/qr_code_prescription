import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_prescription/components/prescrip_card.dart';
import 'package:qr_code_prescription/screens/prescription/personal_list_prescription.dart';
import 'package:qr_code_prescription/services/dtos/prescription.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RecentPres extends StatelessWidget {
  RecentPres({Key? key, required this.listPres}) : super(key: key);
  final _controller = PageController();
  final List<Prescription> listPres;
  final colorList = [
    CupertinoColors.activeBlue,
    kPrimaryColor,
    CupertinoColors.activeGreen
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Đơn thuốc gần đây',
              style: kTitleStyle,
            ),
            TextButton(
              child: Text(
                'Tất cả',
                style: TextStyle(
                  color: Color(MyColors.yellow01),
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, ListPresScreen.routeName);
              },
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 200,
          child: PageView(
            scrollDirection: Axis.horizontal,
            controller: _controller,
            children: [
              for (Prescription pres in listPres)
                HomePresCard(
                  prescription: pres,
                  color: colorList[listPres.indexOf(pres)],
                ),
              // PresCard(
              //   presId: 1,
              //   hospital: 'Bệnh viện 1',
              //   diagnostic: 'Đau đầu',
              //   createDate: '5/2022',
              //   color: CupertinoColors.activeBlue,
              // ),
              // PresCard(
              //   presId: 2,
              //   hospital: 'Bệnh viện 1',
              //   diagnostic: 'Đau dạ dày',
              //   createDate: '4/2022',
              //   color: kPrimaryColor,
              // ),
              // PresCard(
              //   presId: 3,
              //   hospital: 'Bệnh viện 1',
              //   diagnostic: 'Đau vai',
              //   createDate: '3/2022',
              //   color: CupertinoColors.activeGreen,
              // ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Center(
          child: SmoothPageIndicator(
            controller: _controller,
            count: listPres.length,
            effect: const ExpandingDotsEffect(
              activeDotColor: CupertinoColors.activeBlue,
              dotColor: CupertinoColors.inactiveGray,
            ),
          ),
        ),
      ],
    );
  }
}
