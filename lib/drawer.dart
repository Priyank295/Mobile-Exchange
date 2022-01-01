import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icon.dart';

import 'main_widget.dart';
import 'menu_widget.dart';

bool menu = true;
bool close = false;
bool icon = true;

GlobalKey<SliderMenuContainerState> _key =
    new GlobalKey<SliderMenuContainerState>();

class Drawer extends StatefulWidget {
  const Drawer({Key? key}) : super(key: key);

  @override
  _DrawerState createState() => _DrawerState();
}

class _DrawerState extends State<Drawer> {
  late String title;
  @override
  void initState() {
    title = "MBX";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SliderMenuContainer(
          key: _key,
          appBarHeight: 90,
          appBarPadding: EdgeInsets.symmetric(horizontal: 10),
          animationDuration: 1,
          appBarColor: Colors.white,
          isDraggable: false,
          drawerIconSize: 50,
          // sliderMenuOpenSize: 200,
          drawerIcon: Container(
            margin: EdgeInsets.only(right: 10, top: 30),
            child: GestureDetector(
              onTap: () {
                if (menu == true) {
                  _key.currentState!.openDrawer();
                  setState(() {
                    menu = false;
                  });
                } else {
                  _key.currentState!.closeDrawer();
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
          slideDirection: SlideDirection.RIGHT_TO_LEFT,
          title: Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
          sliderMenu: MenuWidget(
              // onItemClick: (title) {
              //   _key.currentState!.closeDrawer();
              //   setState(() {
              //     this.title = title;
              //   });
              // },
              ),
          sliderMain: MainWidget()),
    );
  }
}
