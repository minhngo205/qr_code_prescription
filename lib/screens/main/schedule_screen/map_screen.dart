import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:qr_code_prescription/screens/loading/loading_screen.dart';
import 'package:qr_code_prescription/utils/constants.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LocationData curentLocation;
  Set<Marker> _markers = Set<Marker>();
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor hospitalIcon;
  late BitmapDescriptor pharmacyIcon;
  bool isLoading = true;
  String? selectedValue;

  void getCurentLocation() {
    Location location = Location();
    location.getLocation().then((location) => {
          debugPrint(location.toString()),
          setState(() {
            curentLocation = location;
            _markers.add(Marker(
                markerId: const MarkerId("curentLocation"),
                position:
                    LatLng(curentLocation.latitude!, curentLocation.longitude!),
                icon: sourceIcon));
            isLoading = false;
          })
        });
  }

  @override
  void initState() {
    getCurentLocation();
    super.initState();
  }

  void setSourceAndDestinationMarkerIcons(BuildContext context) async {
    final Uint8List source =
        await getBytesFromAsset('assets/icons/pin.png', 100);

    final Uint8List hospital =
        await getBytesFromAsset('assets/icons/hospital_marker.png', 100);

    final Uint8List drugstore =
        await getBytesFromAsset('assets/icons/pharmacy_marker.png', 100);

    sourceIcon = BitmapDescriptor.fromBytes(source);

    hospitalIcon = BitmapDescriptor.fromBytes(hospital);

    pharmacyIcon = BitmapDescriptor.fromBytes(drugstore);
  }

  @override
  Widget build(BuildContext context) {
    setSourceAndDestinationMarkerIcons(context);
    return isLoading
        ? Loading(haveText: true)
        : Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        curentLocation.latitude!,
                        curentLocation.longitude!,
                      ),
                      zoom: 13.5,
                    ),
                    markers: _markers,
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: MapUserBadge(
                    icon: getIcon(selectedValue),
                    onTabSelected: (value) => setState(
                      () {
                        selectedValue = value;
                        getLocationData();
                      },
                    ),
                  ),
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
        return const Icon(CupertinoIcons.chevron_down);
    }
  }

  void getLocationData() {
    _markers.clear();
    getCurentLocation();
  }
}

class MapUserBadge extends StatelessWidget {
  final ValueChanged<String?> onTabSelected;
  final Widget icon;

  const MapUserBadge({
    Key? key,
    required this.onTabSelected,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 0, bottom: 10, left: 20, right: 20),
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
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: "Chọn một địa điểm",
        ),
        onChanged: onTabSelected,
        items: dropdownItems,
        icon: icon,
      ),
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

// getDropdownChild(String text, String imagePath) {
//   return Row(
//     children: [
//       Expanded(
//           child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             text,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       )),
//     ],
//   );
// }
