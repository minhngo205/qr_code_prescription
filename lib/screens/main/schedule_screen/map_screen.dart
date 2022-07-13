import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:qr_code_prescription/components/default_button.dart';
import 'package:qr_code_prescription/screens/authen/login/login_screen.dart';
import 'package:qr_code_prescription/screens/list_screen/detail_hospital_drugstore/hospital_drugstore_detail.dart';
import 'package:qr_code_prescription/screens/loading/loading_screen.dart';
import 'package:qr_code_prescription/model/dtos/hospital_drugstore.dart';
import 'package:qr_code_prescription/services/storage/storage_service.dart';
import 'package:qr_code_prescription/services/user_service/user_service.dart';
import 'package:qr_code_prescription/utils/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationData currentLocation;
  final Set<Marker> _markers = <Marker>{};
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor hospitalIcon;
  late BitmapDescriptor pharmacyIcon;
  bool isLoading = true;
  String? selectedValue;
  UserRepository userRepository = UserRepository();
  StorageRepository storageRepository = StorageRepository();

  void getCurentLocation() {
    Location location = Location();
    location.getLocation().then((location) => {
          debugPrint(location.toString()),
          setState(() {
            currentLocation = location;
            _markers.add(Marker(
                markerId: const MarkerId("curentLocation"),
                position: LatLng(
                    currentLocation.latitude!, currentLocation.longitude!),
                icon: sourceIcon));
            isLoading = false;
          })
        });
  }

  Map markerIcons = {};
  // Map dropdownMenuIcon()

  @override
  void initState() {
    setSourceAndDestinationMarkerIcons(context);
    super.initState();
  }

  void setSourceAndDestinationMarkerIcons(BuildContext context) async {
    final Uint8List source =
        await getBytesFromAsset('assets/icons/pin.png', 100);

    final Uint8List hospital =
        await getBytesFromAsset('assets/icons/hospital_marker.png', 100);

    final Uint8List drugstore =
        await getBytesFromAsset('assets/icons/pharmacy_marker.png', 100);

    setState(() {
      sourceIcon = BitmapDescriptor.fromBytes(source);
      hospitalIcon = BitmapDescriptor.fromBytes(hospital);
      pharmacyIcon = BitmapDescriptor.fromBytes(drugstore);
      markerIcons = {'hospitals': hospitalIcon, 'drugstores': pharmacyIcon};
      getCurentLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading(haveText: true)
        : Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        currentLocation.latitude!,
                        currentLocation.longitude!,
                      ),
                      zoom: 13.5,
                    ),
                    markers: _markers,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(
                        top: 0, bottom: 10, left: 20, right: 20),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                              offset: Offset.zero)
                        ]),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Chọn một địa điểm",
                      ),
                      value: selectedValue,
                      onChanged: (String? value) {
                        setState(() {
                          selectedValue = value;
                        });
                        getLocationData();
                      },
                      items: dropdownItems,
                      icon: getIcon(selectedValue),
                    ),
                  ),
                  // MapUserBadge(
                  //   icon: getIcon(selectedValue),
                  //   onTabSelected: (value) => setState(
                  //     () {
                  //       selectedValue = value;
                  //       getLocationData();
                  //     },
                  //   ),
                  // ),
                ),
              ],
            ),
          );
  }

  getIcon(String? selectedValue) {
    switch (selectedValue) {
      case "hospitals":
        return Image.asset(
          "assets/icons/hospital_marker.png",
          width: 50,
        );
      case "drugstores":
        return Image.asset(
          "assets/icons/pharmacy_marker.png",
          width: 50,
        );
      default:
        return const Icon(CupertinoIcons.location_solid);
    }
  }

  getLocationData() async {
    setState(() {
      isLoading = true;
    });
    _markers.clear();
    getCurentLocation();
    // debugPrint(sel)
    var response = await userRepository.getLocationNearBy(
      selectedValue!,
      20,
      currentLocation.longitude!,
      currentLocation.latitude!,
    );

    if (response == RequestStatus.RefreshFail) {
      storageRepository.deleteToken();
      Navigator.pushNamedAndRemoveUntil(
          context, LoginScreen.routeName, (route) => false);
    } else if (response == null) {
      setState(() {
        isLoading = false;
      });
      Alert(
        context: context,
        type: AlertType.error,
        title: "Lỗi",
        desc: "Đã có lỗi xảy ra trong quá trình lấy dữ liệu",
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
    } else {
      debugPrint(response.toString());
      setState(() {
        for (HospitalDrugstore info in response) {
          _markers.add(
            Marker(
              markerId: MarkerId(info.name),
              position: LatLng(
                double.parse(info.latitude),
                double.parse(info.longitude),
              ),
              icon: markerIcons[selectedValue],
              onTap: () {
                showPopUp(info);
              },
            ),
          );
        }
        isLoading = false;
      });
    }
  }

  showPopUp(HospitalDrugstore info) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(vertical: 250),
          elevation: 10,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.transparent,
            ),
            child: MapLocationPopup(
              info: info,
              currentLocation: currentLocation,
              pinAsset: getIcon(selectedValue),
            ),
          ),
        );
      },
    );
  }
}

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(child: Text("Bệnh viện"), value: "hospitals"),
    const DropdownMenuItem(child: Text("Nhà thuốc"), value: "drugstores"),
  ];
  return menuItems;
}

class MapLocationPopup extends StatelessWidget {
  const MapLocationPopup({
    Key? key,
    required this.info,
    required this.currentLocation,
    required this.pinAsset,
  }) : super(key: key);

  final HospitalDrugstore info;
  final LocationData currentLocation;
  final Image pinAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset.zero,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      ClipOval(
                        child: Image(
                          image: CachedNetworkImageProvider(info.background),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Positioned(
                      //   bottom: -10,
                      //   right: -10,
                      //   child: CategoryIcon(
                      //       color: this.subCategory!.color,
                      //       iconName: this.subCategory!.icon,
                      //       size: 20,
                      //       padding: 5),
                      // )
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(info.name,
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                        Text(info.address),
                        Text(
                            "Cách vị trí hiện tại: " +
                                calculateDistance(
                                  currentLocation.latitude,
                                  currentLocation.longitude,
                                  double.parse(info.latitude),
                                  double.parse(info.longitude),
                                ).toStringAsFixed(2) +
                                " km",
                            style: const TextStyle(
                                color: CupertinoColors.activeBlue))
                      ],
                    ),
                  ),
                  pinAsset
                  // Icon(pinAsset,
                  //     color: this.subCategory!.color, size: 50)
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DefaultButton(
                  text: "Huỷ",
                  backgroundColor: Colors.grey[200],
                  textColor: CupertinoColors.black,
                  width: 150,
                  press: () {
                    Navigator.pop(context);
                  },
                ),
                DefaultButton(
                  text: "Chi tiết",
                  backgroundColor: CupertinoColors.activeBlue,
                  textColor: CupertinoColors.white,
                  width: 150,
                  press: () {
                    Navigator.pushNamed(
                      context,
                      HospitalDrugstoreDetail.routeName,
                      arguments: HospitalDrugstoreDetailArguments(info),
                    );
                  },
                ),
              ],
            )
            // Container(
            //     child: Column(
            //   children: [
            //     const SizedBox(height: 20),
            //     Row(
            //       children: [
            //         Container(
            //           width: 50,
            //           height: 50,
            //           decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(50),
            //               image: const DecorationImage(
            //                   image: AssetImage('assets/imgs/farmer.jpeg'),
            //                   fit: BoxFit.cover),
            //               border: Border.all(
            //                   color: this.subCategory!.color!, width: 4)),
            //         ),
            //         const SizedBox(width: 20),
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const Text('Jose Gonzalez',
            //                 style:
            //                     const TextStyle(fontWeight: FontWeight.bold)),
            //             const Text(
            //                 'Autopista Duarte\nCarretera Duarte Vieja #225')
            //           ],
            //         )
            //       ],
            //     )
            //   ],
            // ))
          ],
        ));
  }
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
