import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_prescription/screens/list_screen/detail_hospital_drugstore/hospital_drugstore_detail.dart';
import 'package:qr_code_prescription/services/dtos/hospital_drugstore.dart';

class HospitalDrugstoreCard extends StatelessWidget {
  final HospitalDrugstore hospitalDrugstore;

  const HospitalDrugstoreCard({Key? key, required this.hospitalDrugstore})
      : super(key: key);

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
              trailing: hospitalDrugstore.user.role == "hospital"
                  ? const Icon(Icons.medical_services)
                  : const Icon(CupertinoIcons.lab_flask_solid),
            ),
            SizedBox(
              height: 200.0,
              child: Ink.image(
                image: hospitalDrugstore.user.role == "hospital"
                    ? const AssetImage("assets/images/hospital.png")
                    : const AssetImage("assets/images/pharmacy.png"),
                fit: BoxFit.fitHeight,
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
