import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_prescription/screens/list_screen/detail_hospital_drugstore/hospital_drugstore_detail.dart';
import 'package:qr_code_prescription/model/dtos/hospital_drugstore.dart';

class HospitalDrugstoreCard extends StatelessWidget {
  final HospitalDrugstore hospitalDrugstore;

  HospitalDrugstoreCard({Key? key, required this.hospitalDrugstore})
      : super(key: key);

  final Map trailing = {
    'hospital': const Icon(Icons.medical_services),
    'drugstore': const Icon(CupertinoIcons.lab_flask_solid)
  };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          HospitalDrugstoreDetail.routeName,
          arguments: HospitalDrugstoreDetailArguments(hospitalDrugstore),
        );
      },
      child: Card(
        elevation: 4.0,
        child: Column(
          children: [
            ListTile(
              title: Text(hospitalDrugstore.name),
              trailing: trailing[hospitalDrugstore.user.role],
            ),
            SizedBox(
              height: 200.0,
              child: Image(
                image: CachedNetworkImageProvider(hospitalDrugstore.background),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
              child: Text(hospitalDrugstore.address),
            ),
            // ButtonBar(
            //   children: [
            //     TextButton(
            //       child: Text(dateformater(hospitalDrugstore.createdAt)),
            //       onPressed: () {/* ... */},
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
