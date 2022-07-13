import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_prescription/screens/list_screen/component/hospital_drugstore_listview.dart';
import 'package:qr_code_prescription/screens/list_screen/component/prescription_listview.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);
  static String routeName = "/list";

  @override
  State<ListScreen> createState() => _ListScreenState();
}

String getTitle(String arg) {
  switch (arg) {
    case "prescription":
      return "Đơn thuốc của tôi";
    case "hospitals":
      return "Danh sách bệnh viện";
    case "drugstores":
      return "Danh sách nhà thuốc";
    default:
      return "";
  }
}

getListView(String arg) {
  switch (arg) {
    case "prescription":
      return const PrescriptionListView();
    case "hospitals":
    case "drugstores":
      return HospitalDrugstoreListView(pageName: arg);
    default:
      return "";
  }
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ListScreenArguments;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: CupertinoColors.activeBlue,
        title: Text(
          getTitle(args.title),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: getListView(args.title),
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     //crossAxisAlignment: CrossAxisAlignment.stretch,
      //     children: <Widget>[
      //       const UserDetailCard(),
      //       Column(
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: <Widget>[
      //           Padding(
      //             padding: EdgeInsets.symmetric(
      //               horizontal: 10,
      //             ),
      //             child: Container(
      //               height: MediaQuery.of(context).size.height *
      //                   0.68, //height of TabBarView
      //               padding: const EdgeInsets.symmetric(
      //                 horizontal: 10,
      //               ),
      //               child: PrescriptionListView(),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class ListScreenArguments {
  final String title;
  ListScreenArguments(this.title);
}
