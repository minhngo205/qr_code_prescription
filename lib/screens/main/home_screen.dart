import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
            child: Row(
              children: const [
                Text(
                  'Đơn thuốc ',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  'của tôi',
                  style: TextStyle(fontSize: 28),
                ),
              ],
            ),
          ),
        ],
      )),
    );
    // return Scaffold(
    //   body: CustomScrollView(
    //     slivers: [
    //       SliverAppBar(
    //         systemOverlayStyle: const SystemUiOverlayStyle(
    //           // Status bar color
    //           statusBarColor: Colors.white,

    //           // Status bar brightness (optional)
    //           statusBarIconBrightness:
    //               Brightness.dark, // For Android (dark icons)
    //           statusBarBrightness: Brightness.light, // For iOS (dark icons)
    //         ),
    //         floating: true,
    //         pinned: true,
    //         snap: false,
    //         centerTitle: false,
    //         title: const Text('Sổ thuốc điện tử'),
    //         actions: [
    //           IconButton(
    //             icon: const Icon(Icons.medical_information),
    //             onPressed: () {},
    //           ),
    //         ],
    //         bottom: AppBar(
    //           title: Container(
    //             width: double.infinity,
    //             height: 40,
    //             color: Colors.white,
    //             child: const Center(
    //               child: TextField(
    //                 decoration: InputDecoration(
    //                     hintText: 'Search for something',
    //                     prefixIcon: Icon(Icons.search),
    //                     suffixIcon: Icon(Icons.camera_alt)),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //       // Other Sliver Widgets
    //       SliverList(
    //         delegate: SliverChildListDelegate([
    //           const SizedBox(
    //             height: 400,
    //             child: Center(
    //               child: Text(
    //                 'This is an awesome shopping platform',
    //               ),
    //             ),
    //           ),
    //           Container(
    //             height: 1000,
    //             color: Colors.pink,
    //           ),
    //         ]),
    //       ),
    //     ],
    //   ),
    // );
  }
}
