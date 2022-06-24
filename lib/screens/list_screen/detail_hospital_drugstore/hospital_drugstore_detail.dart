import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_prescription/screens/loading/loading_screen.dart';
import 'package:qr_code_prescription/services/dtos/hospital_drugstore.dart';
import 'package:qr_code_prescription/services/public_service/public_service.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HospitalDrugstoreDetail extends StatefulWidget {
  const HospitalDrugstoreDetail({Key? key}) : super(key: key);
  static String routeName = "/hospital_drugstore/detail";

  @override
  State<HospitalDrugstoreDetail> createState() =>
      _HospitalDrugstoreDetailState();
}

class _HospitalDrugstoreDetailState extends State<HospitalDrugstoreDetail> {
  bool isLoading = false;
  late HospitalDrugstore hospitalDrugstore;

  refreshData(int detailID, String role) async {
    setState(() {
      isLoading = true;
    });

    PublicService publicService = PublicService();
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

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as HospitalDrugstoreDetailArguments;
    setState(() {
      hospitalDrugstore = args.detail;
    });
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: hospitalDrugstore.user.role == "hospital"
                ? const Text('Bệnh viện')
                : const Text('Nhà thuốc'),
            backgroundColor: CupertinoColors.activeBlue,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image(
                image: hospitalDrugstore.user.role == "hospital"
                    ? const AssetImage('assets/images/hospital.png')
                    : const AssetImage('assets/images/pharmacy.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: DetailBody(info: hospitalDrugstore),
          )
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  final HospitalDrugstore info;
  const DetailBody({
    Key? key,
    required this.info,
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
          const SizedBox(
            height: 15,
          ),
          const DoctorInfo(),
          const SizedBox(
            height: 30,
          ),
          Text(
            "Địa chỉ",
            style: kTitleStyle,
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
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            'Địa chỉ',
            style: kTitleStyle,
          ),
          const SizedBox(
            height: 25,
          ),
          const DoctorLocation(),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Color(MyColors.primary),
              ),
            ),
            child: const Text('Thông tin chi tiết'),
            onPressed: () => {},
          )
        ],
      ),
    );
  }
}

class DoctorLocation extends StatelessWidget {
  const DoctorLocation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset("assets/images/fakemap.jpg")
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

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        NumberCard(
          label: 'Patients',
          value: '100+',
        ),
        SizedBox(width: 15),
        NumberCard(
          label: 'Experiences',
          value: '10 years',
        ),
        SizedBox(width: 15),
        NumberCard(
          label: 'Rating',
          value: '4.0',
        ),
      ],
    );
  }
}

class AboutDoctor extends StatelessWidget {
  final String title;
  final String desc;
  const AboutDoctor({
    Key? key,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class NumberCard extends StatelessWidget {
  final String label;
  final String value;

  const NumberCard({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(MyColors.bg03),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 15,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Color(MyColors.grey02),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: TextStyle(
                color: Color(MyColors.header01),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
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
    return Container(
      child: Card(
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
                          fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      hospitalDrugstore.address,
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
      ),
    );
  }
}

class HospitalDrugstoreDetailArguments {
  final HospitalDrugstore detail;
  HospitalDrugstoreDetailArguments(this.detail);
}
