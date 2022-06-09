import 'package:flutter/material.dart';
import 'package:qr_code_prescription/components/custom_clipper.dart';
import 'package:qr_code_prescription/utils/constants.dart';

class CardItems extends StatelessWidget {
  final Image image;
  final String title;
  final Color color;

  const CardItems({
    Key? key,
    required this.image,
    required this.title,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 100,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        shape: BoxShape.rectangle,
        color: Colors.white,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            child: ClipPath(
              clipper: MyCustomClipper(clipType: ClipType.halfCircle),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  color: color.withOpacity(0.1),
                ),
                height: 100,
                width: 100,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // Icon and Hearbeat
                image,
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Chưa có tiền sử bệnh",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kTextColor),
                        maxLines: 3,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
