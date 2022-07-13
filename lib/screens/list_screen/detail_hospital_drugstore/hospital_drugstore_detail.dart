import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qr_code_prescription/components/default_button.dart';
import 'package:qr_code_prescription/screens/loading/loading_screen.dart';
import 'package:qr_code_prescription/model/dtos/hospital_drugstore.dart';
import 'package:qr_code_prescription/services/public_service/public_service.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HospitalDrugstoreDetail extends StatefulWidget {
  const HospitalDrugstoreDetail({Key? key}) : super(key: key);
  static String routeName = "/hospital_drugstore/detail";

  @override
  State<HospitalDrugstoreDetail> createState() =>
      _HospitalDrugstoreDetailState();
}

class _HospitalDrugstoreDetailState extends State<HospitalDrugstoreDetail> {
  bool isLoading = true;
  late HospitalDrugstore hospitalDrugstore;
  PublicService publicService = PublicService();

  late BitmapDescriptor hospitalIcon;
  late BitmapDescriptor pharmacyIcon;

  final Map titles = {
    'hospital': const Text('Bệnh viện'),
    'drugstore': const Text('Nhà thuốc')
  };

  refreshData(int detailID, String role) async {
    HospitalDrugstore? detail =
        await publicService.getDetailHospital(role + "s", detailID);

    if (detail != null) {
      setState(() {
        hospitalDrugstore = detail;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });

      Alert(
        context: context,
        type: AlertType.error,
        title: "Lỗi",
        desc: "Đã có lỗi xảy ra trong quá trình làm mới, xin hãy thử lại",
        buttons: [
          DialogButton(
            child: const Text(
              "Huỷ",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: CupertinoColors.activeBlue,
          ),
        ],
      ).show();
    }
  }

  void setSourceAndDestinationMarkerIcons(BuildContext context) async {
    final Uint8List hospital =
        await getBytesFromAsset('assets/icons/hospital_marker.png', 100);

    final Uint8List drugstore =
        await getBytesFromAsset('assets/icons/pharmacy_marker.png', 100);

    setState(() {
      hospitalIcon = BitmapDescriptor.fromBytes(hospital);
      pharmacyIcon = BitmapDescriptor.fromBytes(drugstore);
      isLoading = false;
    });
  }

  @override
  void initState() {
    setSourceAndDestinationMarkerIcons(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as HospitalDrugstoreDetailArguments;
    setState(() {
      hospitalDrugstore = args.detail;
    });
    return isLoading
        ? Loading(haveText: false)
        : Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  title: titles[hospitalDrugstore.user.role],
                  backgroundColor: CupertinoColors.activeBlue,
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image(
                      image: CachedNetworkImageProvider(
                          hospitalDrugstore.background),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: DetailBody(
                    info: hospitalDrugstore,
                    hospital: hospitalIcon,
                    drugstore: pharmacyIcon,
                  ),
                )
              ],
            ),
          );
  }
}

class DetailBody extends StatelessWidget {
  final HospitalDrugstore info;
  final BitmapDescriptor hospital;
  final BitmapDescriptor drugstore;

  const DetailBody({
    Key? key,
    required this.info,
    required this.hospital,
    required this.drugstore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NameBannerCard(hospitalDrugstore: info),
          // const SizedBox(
          //   height: 15,
          // ),
          // const DoctorInfo(),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Địa chỉ",
            style: TextStyle(
              color: Color(MyColors.header01),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            info.address,
            style: const TextStyle(
                color: CupertinoColors.black,
                fontWeight: FontWeight.w500,
                height: 1.5,
                fontSize: 15),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Số điện thoại",
            style: TextStyle(
              color: Color(MyColors.header01),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            info.user.phoneNumber,
            style: const TextStyle(
              color: CupertinoColors.black,
              fontWeight: FontWeight.w500,
              height: 1.5,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Email",
            style: TextStyle(
              color: Color(MyColors.header01),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            info.user.email.isEmpty ? "Chưa cập nhật email" : info.user.email,
            style: const TextStyle(
              color: CupertinoColors.black,
              fontWeight: FontWeight.w500,
              height: 1.5,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Trang web",
            style: TextStyle(
              color: Color(MyColors.header01),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            info.website.isEmpty ? "Chưa cập nhật trang web" : info.website,
            style: const TextStyle(
              color: CupertinoColors.black,
              fontWeight: FontWeight.w500,
              height: 1.5,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            'Vị trí',
            style: TextStyle(
              color: Color(MyColors.header01),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          DoctorLocation(
            lat: double.parse(info.latitude),
            long: double.parse(info.longitude),
            icon: info.user.role == "hospital" ? hospital : drugstore,
          ),
          const SizedBox(
            height: 25,
          ),
          DefaultButton(
            backgroundColor: CupertinoColors.activeBlue,
            textColor: CupertinoColors.white,
            text: 'Thông tin chi tiết',
            press: () => {},
          )
        ],
      ),
    );
  }
}

class DoctorLocation extends StatelessWidget {
  const DoctorLocation({
    Key? key,
    required this.lat,
    required this.long,
    required this.icon,
  }) : super(key: key);

  final double lat;
  final double long;
  final BitmapDescriptor icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, long),
              zoom: 16,
            ),
            markers: {
              Marker(
                markerId: const MarkerId("curentLocation"),
                position: LatLng(lat, long),
                icon: icon,
              ),
            },
            zoomControlsEnabled: false,
          )
          // Image.asset("assets/images/fakemap.jpg")
          // FlutterMap(
          //   options: MapOptions(
          //     center: latLng.LatLng(51.5, -0.09),
          //     zoom: 13.0,
          //   ),
          //   layers: [
          //     TileLayerOptions(
          //       urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          //       subdomains: ['a', 'b', 'c'],
          //     ),
          //   ],
          // ),
          ),
    );
  }
}

class NameBannerCard extends StatelessWidget {
  final HospitalDrugstore hospitalDrugstore;
  const NameBannerCard({
    Key? key,
    required this.hospitalDrugstore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hospitalDrugstore.name,
                    style: const TextStyle(
                      color: CupertinoColors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    hospitalDrugstore.description.isEmpty
                        ? "Chưa cập nhật mô tả"
                        : hospitalDrugstore.description,
                    style: TextStyle(
                      color: Color(MyColors.grey02),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Image(
            //   image: AssetImage('assets/doctor01.jpeg'),
            //   width: 100,
            // )
          ],
        ),
      ),
    );
  }
}

class HospitalDrugstoreDetailArguments {
  final HospitalDrugstore detail;
  HospitalDrugstoreDetailArguments(this.detail);
}
