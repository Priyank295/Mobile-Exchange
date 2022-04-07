import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:line_icons/line_icon.dart';
import 'package:mbx/navbar.dart';
import 'package:mbx/menu_widget.dart';
import './main_widget.dart';
import './menu_widget.dart';

bool menu = true;
bool close = false;
bool icon = true;

// GlobalKey<SliderMenuContainerState> _key =
//     new GlobalKey<SliderMenuContainerState>();

// ignore: unused_element

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String title;
  GlobalKey<SliderDrawerState> _key = GlobalKey<SliderDrawerState>();
  @override
  void initState() {
    title = "MBX";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SliderDrawer(
          key: _key,
          appBar: SliderAppBar(
            title: Container(
              margin: EdgeInsets.only(top: 25),
              child: SvgPicture.asset(
                "assets/logo.svg",
                height: 40,
                width: 40,
              ),
            ),
            appBarHeight: 90,
            appBarPadding: EdgeInsets.symmetric(horizontal: 10),
            appBarColor: Colors.white,
            drawerIconSize: 50,
            drawerIcon: Container(
              margin: EdgeInsets.only(right: 10, top: 30),
              child: GestureDetector(
                onTap: () {
                  if (menu == true) {
                    _key.currentState!.openSlider();
                    setState(() {
                      menu = false;
                    });
                  } else {
                    _key.currentState!.closeSlider();
                    setState(() {
                      menu = true;
                    });
                  }
                },
                child: menu
                    ? SvgPicture.asset('assets/Menu.svg')
                    : LineIcon(Icons.close),
              ),
            ),
          ),
          animationDuration: 1,
          isDraggable: false,

          // sliderMenuOpenSize: 200,

          slideDirection: SlideDirection.RIGHT_TO_LEFT,
          slider: MenuWidget(
              // onItemClick: (title) {
              //   _key.currentState!.closeDrawer();
              //   setState(() {
              //     this.title = title;
              //   });
              // },
              ),
          child: MainWidget()),
    );
  }
}
