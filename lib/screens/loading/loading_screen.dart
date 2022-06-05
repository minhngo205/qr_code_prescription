import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  bool haveText = true;
  Loading({Key? key, required this.haveText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.white,
      child: Center(
        child: Container(
          width: 90.0,
          height: 90.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: CupertinoColors.activeBlue,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SpinKitPouringHourGlassRefined(
                color: CupertinoColors.white,
              ),
              haveText
                  ? Column(
                      children: const [
                        SizedBox(height: 10),
                        Text(
                          "Đang tải ...",
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ],
                    )
                  : const SizedBox(width: 0),
            ],
          ),
        ),
      ),
    );
  }
}
