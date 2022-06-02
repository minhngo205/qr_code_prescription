import 'package:flutter/material.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'package:qr_code_prescription/utils/size_config.dart';


// // import 'dart:math' as math;

// class BottomNavigation extends StatelessWidget {
//   final List<IconData> itemIcons;
//   final IconData centerIcon;
//   final int selectedIndex;
//   final Function(int) onItemPressed;

//   const BottomNavigation({
//     Key? key,
//     required this.itemIcons,
//     required this.centerIcon,
//     required this.selectedIndex,
//     required this.onItemPressed,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: getRelativeHeight(0.108),
//       child: Stack(
//         children: [
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: getRelativeHeight(0.08),
//               color: Colors.white,
//               child: Padding(
//                 padding:
//                     EdgeInsets.symmetric(horizontal: getRelativeWidth(0.1)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               onItemPressed(0);
//                             },
//                             child: Icon(
//                               itemIcons[0],
//                               color: selectedIndex == 0
//                                   ? kBlueDarkColor
//                                   : kLightTextColor,
//                               size: selectedIndex == 0
//                                   ? getRelativeWidth(0.07)
//                                   : null,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               onItemPressed(1);
//                             },
//                             child: Icon(
//                               itemIcons[1],
//                               color: selectedIndex == 1
//                                   ? kBlueDarkColor
//                                   : kLightTextColor,
//                               size: selectedIndex == 1
//                                   ? getRelativeWidth(0.07)
//                                   : null,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Spacer(flex: 3),
//                     Expanded(
//                       flex: 2,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               onItemPressed(2);
//                             },
//                             child: Icon(
//                               itemIcons[2],
//                               color: selectedIndex == 2
//                                   ? kBlueDarkColor
//                                   : kLightTextColor,
//                               size: selectedIndex == 2
//                                   ? getRelativeWidth(0.07)
//                                   : null,
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               onItemPressed(3);
//                             },
//                             child: Icon(
//                               itemIcons[3],
//                               color: selectedIndex == 3
//                                   ? kBlueDarkColor
//                                   : kLightTextColor,
//                               size: selectedIndex == 3
//                                   ? getRelativeWidth(0.07)
//                                   : null,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned.fill(
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: Transform.rotate(
//                 angle: 0,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         blurRadius: 25,
//                         offset: const Offset(0, 5),
//                         color: kBlueDarkColor.withOpacity(0.75),
//                       )
//                     ],
//                     borderRadius: const BorderRadius.all(Radius.circular(18)),
//                     gradient: const LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         kBlueLightColor,
//                         kBlueDarkColor,
//                       ],
//                     ),
//                   ),
//                   height: getRelativeWidth(0.135),
//                   width: getRelativeWidth(0.135),
//                   child: Center(
//                       child: Transform.rotate(
//                     angle: 0,
//                     child: Icon(
//                       centerIcon,
//                       color: Colors.white,
//                       size: getRelativeWidth(0.07),
//                     ),
//                   )),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 5,
//         child: SizedBox(
//           height: 60,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   MaterialButton(
//                     minWidth: 40,
//                     onPressed: () {
//                       setState(() {
//                         _selectedIndex = 0;
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.home,
//                           color: _selectedIndex == 0
//                               ? kBlueDarkColor
//                               : kLightTextColor,
//                         ),
//                         Visibility(
//                           child: Text(
//                             "Chính",
//                             style: TextStyle(
//                               color: _selectedIndex == 0
//                                   ? kBlueDarkColor
//                                   : kLightTextColor,
//                             ),
//                           ),
//                           visible: true,
//                         )
//                       ],
//                     ),
//                   ),
//                   MaterialButton(
//                     minWidth: 40,
//                     onPressed: () {
//                       setState(() {
//                         _selectedIndex = 1;
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.notifications,
//                           color: _selectedIndex == 1
//                               ? kBlueDarkColor
//                               : kLightTextColor,
//                         ),
//                         Visibility(
//                           child: Text(
//                             "Thông báo",
//                             style: TextStyle(
//                               color: _selectedIndex == 1
//                                   ? kBlueDarkColor
//                                   : kLightTextColor,
//                             ),
//                           ),
//                           visible: true,
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   MaterialButton(
//                     minWidth: 40,
//                     onPressed: () {
//                       setState(() {
//                         _selectedIndex = 2;
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.discount,
//                           color: _selectedIndex == 2
//                               ? kBlueDarkColor
//                               : kLightTextColor,
//                         ),
//                         Text(
//                           "Ưu đãi",
//                           style: TextStyle(
//                             color: _selectedIndex == 2
//                                 ? kBlueDarkColor
//                                 : kLightTextColor,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   MaterialButton(
//                     minWidth: 40,
//                     onPressed: () {
//                       setState(() {
//                         _selectedIndex = 3;
//                       });
//                     },
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.account_box,
//                           color: _selectedIndex == 3
//                               ? kBlueDarkColor
//                               : kLightTextColor,
//                         ),
//                         Text(
//                           "Cá nhân",
//                           style: TextStyle(
//                             color: _selectedIndex == 3
//                                 ? kBlueDarkColor
//                                 : kLightTextColor,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),