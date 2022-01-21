import 'dart:io';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:device_apps/device_apps.dart';
import 'package:mbx/loginpage.dart';

class CheckMail extends StatefulWidget {
  const CheckMail({Key? key}) : super(key: key);

  @override
  State<CheckMail> createState() => _CheckMailState();
}

class _CheckMailState extends State<CheckMail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xfff6342E8).withOpacity(0.2),
                borderRadius: BorderRadius.circular(30)),
            child: Lottie.asset(
              "assets/email2.json",
              height: 150,
              width: 150,
              frameRate: FrameRate(60),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Container(
            // margin: EdgeInsets.only(left: 40),
            child: Text("Check your mail",
                style: TextStyle(
                    fontFamily: "Lato",
                    fontSize: 30,
                    fontWeight: FontWeight.w800)),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            // margin: EdgeInsets.only(left: 50),
            height: 50,
            width: 250,
            child: Center(
              child: Text(
                  "We have sent a password recover instructions to your email.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: "Lato", fontSize: 14)),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              try {
                getApps();
                // AppAvailability.launchApp("com.google.android.gm");

              } catch (e) {
                print(e);
              }
            },
            child: Container(
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Color(0xFFF6342E8),
              ),
              child: const Center(
                child: Text(
                  "OPEN EMAIL APP",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Lato",
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Get.to(LoginPage());
            },
            child: Text(
              "Back to Login page",
              style: TextStyle(
                  fontFamily: "Lato", color: Color(0xfff6342E8), fontSize: 14),
            ),
          )
        ],
      ),
    ));
  }

  Future<void> getApps() async {
    List<Map<String, String>> _gmailapp;
    if (Platform.isAndroid) {
      _gmailapp = await AppAvailability.getInstalledApps();

      print(await AppAvailability.checkAvailability("com.android.chrome"));
      // Returns: Map<String, String>{app_name: Chrome, package_name: com.android.chrome, versionCode: null, version_name: 55.0.2883.91}

      print(await AppAvailability.isAppEnabled("com.android.chrome"));

      print(await AppAvailability.checkAvailability("com.google.android.gm"));
      // Returns: Map<String, String>{app_name: Chrome, package_name: com.android.chrome, versionCode: null, version_name: 55.0.2883.91}

      print(await AppAvailability.isAppEnabled("com.google.android.gm"));

      AppAvailability.launchApp("com.google.android.gm");
    }
  }

  @override
  void initState() {
    super.initState();
  }
}
