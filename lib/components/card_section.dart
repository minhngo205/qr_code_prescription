import 'package:flutter/material.dart';
import 'package:qr_code_prescription/components/custom_clipper.dart';
import 'package:qr_code_prescription/utils/constants.dart';

class CardSection extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String time;
  final ImageProvider image;
  final bool isDone;
  final String instruction;

  const CardSection(
      {Key? key,
      required this.title,
      required this.value,
      required this.unit,
      required this.time,
      required this.image,
      required this.isDone,
      required this.instruction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(right: 15.0),
        width: 280,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          shape: BoxShape.rectangle,
          color: Colors.white,
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: <Widget>[
            Positioned(
              child: ClipPath(
                clipper: MyCustomClipper(clipType: ClipType.semiCircle),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: kBlueLightColor,
                  ),
                  height: 120,
                  width: 120,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image(
                        image: image,
                        width: 24,
                        height: 24,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      Text(
                        "T???ng: $time",
                        style: const TextStyle(fontSize: 15, color: kTextColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: kTextColor),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '$value $unit',
                              style: const TextStyle(
                                  fontSize: 15, color: kTextColor),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            shape: BoxShape.rectangle,
                            color: isDone
                                ? Theme.of(context).colorScheme.secondary
                                : const Color(0xFFF0F4F8),
                          ),
                          width: 44,
                          height: 44,
                          child: Center(
                            child: Icon(
                              Icons.check,
                              color: isDone
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        onTap: () {
                          debugPrint("Button clicked. Handle button setState");
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        instruction,
                        style: const TextStyle(
                          fontSize: 17,
                          color: kTextColor,
                        ),
                        maxLines: 5,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
