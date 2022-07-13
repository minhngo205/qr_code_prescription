import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_code_prescription/screens/main/home_screen/recent_pres.dart';
import 'package:qr_code_prescription/screens/main/home_screen/welcome_card.dart';
import 'package:qr_code_prescription/screens/list_screen/list_screen.dart';
import 'package:qr_code_prescription/screens/medical_info/user_info_screen.dart';
import 'package:qr_code_prescription/model/dtos/user_info.dart';
import 'package:qr_code_prescription/utils/constants.dart';

import '../../../model/dtos/prescription_item.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    Key? key,
    required this.userInfo,
    required this.listPres,
  }) : super(key: key);
  final UserInfo userInfo;
  final List<PrescriptionItem> listPres;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CupertinoColors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: CupertinoColors.activeBlue,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.search,
              color: CupertinoColors.activeBlue,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            children: [
              const SizedBox(
                height: 20,
              ),
              UserIntro(
                userInfo: widget.userInfo,
              ),
              const SizedBox(height: 30),
              Text(
                'Phòng chống dịch covid-19',
                style: TextStyle(
                  color: Color(MyColors.header01),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // const SearchInput(),
              buildPreventation(),
              const SizedBox(height: 20),
              buildHelpCard(context),
              const SizedBox(height: 20),
              Text(
                'Danh mục',
                style: TextStyle(
                  color: Color(MyColors.header01),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              const CategoryIcons(),
              const SizedBox(height: 20),
              // RecentPres(),
              widget.listPres.isEmpty
                  ? const WelcomeCard()
                  : RecentPres(
                      listPres: widget.listPres,
                    ),
              const SizedBox(
                height: 20,
              ),
              // Text(
              //   'Chức năng',
              //   style: TextStyle(
              //     color: Color(MyColors.header01),
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              // for (var doctor in doctors)
              //   TopDoctorCard(
              //     img: doctor['img'],
              //     doctorName: doctor['doctorName'],
              //     doctorTitle: doctor['doctorTitle'],
              //   )
            ],
          ),
        ),
      ),
    );
  }
}

Row buildPreventation() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: const <Widget>[
      CovidPreventCard(
        assetPath: "assets/images/medical-mask.png",
        title: "Khẩu\ntrang",
      ),
      CovidPreventCard(
        assetPath: "assets/images/disinfectant.png",
        title: "Khử\nkhuẩn",
      ),
      CovidPreventCard(
        assetPath: "assets/images/social-distancing.png",
        title: "Khoảng\ncách",
      ),
      CovidPreventCard(
        assetPath: "assets/images/no-crowd.png",
        title: "Không\ntụ tập",
      ),
      CovidPreventCard(
        assetPath: "assets/images/screening.png",
        title: "Khai báo\ny tế",
      ),
    ],
  );
}

class CovidPreventCard extends StatelessWidget {
  final String assetPath;
  final String title;
  const CovidPreventCard({
    Key? key,
    required this.assetPath,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset(
          assetPath,
          height: 50,
          width: 50,
        ),
        Text(
          title,
          style: const TextStyle(
            color: kTextColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

Widget buildHelpCard(BuildContext context) {
  return SizedBox(
    height: 150,
    width: double.infinity,
    child: Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            // left side padding is 40% of total width
            left: MediaQuery.of(context).size.width * .4,
            top: 20,
            right: 20,
          ),
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF60BE93),
                Color(0xFF1B8D59),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                const TextSpan(
                  text: "Tiêm vaccine\n\n",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                TextSpan(
                  text: "Là biện pháp phòng ngừa COVID-19 tốt nhất",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SvgPicture.asset("assets/images/nurse.svg"),
        ),
        Positioned(
          top: 30,
          right: 10,
          child: SvgPicture.asset("assets/images/virus.svg"),
        ),
      ],
    ),
  );
}

List<Map> categories = [
  {'icon': CupertinoIcons.heart_circle_fill, 'text': 'Sức khoẻ'},
  {'icon': Icons.local_hospital, 'text': 'Bệnh viện'},
  {'icon': Icons.medical_services, 'text': 'Nhà thuốc'},
  {'icon': Icons.local_pharmacy, 'text': 'Đơn thuốc'},
];

class CategoryIcons extends StatelessWidget {
  const CategoryIcons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var category in categories)
          CategoryIcon(
            icon: category['icon'],
            text: category['text'],
            index: categories.indexOf(category),
          ),
      ],
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String text;
  final int index;

  const CategoryIcon({
    Key? key,
    required this.icon,
    required this.text,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: kBlueLightColor,
      onTap: () {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, UserInfoPage.routeName);
            break;
          case 1:
            Navigator.pushNamed(
              context,
              ListScreen.routeName,
              arguments: ListScreenArguments("hospitals"),
            );
            break;
          case 2:
            Navigator.pushNamed(
              context,
              ListScreen.routeName,
              arguments: ListScreenArguments("drugstores"),
            );
            break;
          case 3:
            Navigator.pushNamed(
              context,
              ListScreen.routeName,
              arguments: ListScreenArguments("prescription"),
            );
            break;
          default:
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(MyColors.bg),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon,
                color: CupertinoColors.activeBlue,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              text,
              style: const TextStyle(
                color: kTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(MyColors.bg),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              Icons.search,
              color: Color(MyColors.purple02),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Tìm kiếm...',
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: Color(MyColors.purple01),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserIntro extends StatelessWidget {
  final UserInfo userInfo;
  const UserIntro({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Xin chào',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              "Bạn " + userInfo.name + " 👋",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        const CircleAvatar(
          backgroundImage: AssetImage('assets/icons/app_icon.png'),
        )
      ],
    );
  }
}


// class AppointmentCard extends StatelessWidget {
//   final void Function() onTap;

//   const AppointmentCard({
//     Key? key,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Color(MyColors.primary),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Material(
//             color: Colors.transparent,
//             child: InkWell(
//               onTap: onTap,
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         const CircleAvatar(
//                           backgroundImage: AssetImage('assets/doctor01.jpeg'),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('Dr.Muhammed Syahid',
//                                 style: TextStyle(color: Colors.white)),
//                             const SizedBox(
//                               height: 2,
//                             ),
//                             Text(
//                               'Dental Specialist',
//                               style: TextStyle(color: Color(MyColors.text01)),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     const ScheduleCard(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 20),
//           width: double.infinity,
//           height: 10,
//           decoration: BoxDecoration(
//             color: Color(MyColors.bg02),
//             borderRadius: const BorderRadius.only(
//               bottomRight: Radius.circular(10),
//               bottomLeft: Radius.circular(10),
//             ),
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 40),
//           width: double.infinity,
//           height: 10,
//           decoration: BoxDecoration(
//             color: Color(MyColors.bg03),
//             borderRadius: const BorderRadius.only(
//               bottomRight: Radius.circular(10),
//               bottomLeft: Radius.circular(10),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ScheduleCard extends StatelessWidget {
//   const ScheduleCard({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Color(MyColors.bg01),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: const [
//           Icon(
//             Icons.calendar_today,
//             color: Colors.white,
//             size: 15,
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           Text(
//             'Mon, July 29',
//             style: TextStyle(color: Colors.white),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           Icon(
//             Icons.access_alarm,
//             color: Colors.white,
//             size: 17,
//           ),
//           SizedBox(
//             width: 5,
//           ),
//           Flexible(
//             child: Text(
//               '11:00 ~ 12:10',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }