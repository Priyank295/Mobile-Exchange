import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.1)),
          child: Center(
              child: Lottie.asset("assets/loading.json",
                  frameRate: FrameRate(60), height: 120)),
        ),
      ]),
    );
  }
}
