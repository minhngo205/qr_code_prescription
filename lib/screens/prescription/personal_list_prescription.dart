import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_prescription/components/custom_clipper.dart';
import 'package:qr_code_prescription/components/list_prescription_card.dart';
import 'package:qr_code_prescription/utils/size_config.dart';

class ListPresScreen extends StatefulWidget {
  const ListPresScreen({Key? key}) : super(key: key);
  static String routeName = "/list_pres";

  @override
  State<ListPresScreen> createState() => _ListPresScreenState();
}

class _ListPresScreenState extends State<ListPresScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 228.5 + SizeConfig.statusBarHeight,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                CupertinoIcons.back,
                color: CupertinoColors.white,
              ),
            ),
            floating: false,
            pinned: true,
            snap: false,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "Đơn thuốc của tôi",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
              background: Stack(
                children: [
                  ClipPath(
                    clipper: MyCustomClipper(clipType: ClipType.bottom),
                    child: Container(
                      color: Theme.of(context).colorScheme.secondary,
                      height: 228.5 + SizeConfig.statusBarHeight,
                    ),
                  ),
                  Positioned(
                    right: -45,
                    top: -30,
                    child: ClipOval(
                      child: Container(
                        color: Colors.black.withOpacity(0.05),
                        height: 220,
                        width: 220,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverListCard(),
          SliverListCard(),
          SliverListCard(),
          SliverListCard(),
          SliverListCard(),
          SliverListCard(),
          SliverListCard(),
          SliverListCard(),
          SliverListCard(),
        ],
      ),
    );
  }
}

class SliverListCard extends StatelessWidget {
  const SliverListCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: PrescriptionCard());
  }
}
