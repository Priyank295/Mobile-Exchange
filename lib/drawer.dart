import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icon.dart';

import 'main_widget.dart';
import 'menu_widget.dart';

bool menu = true;
bool close = false;
bool icon = true;

GlobalKey<SliderDrawerState> _key =
    new GlobalKey<SliderDrawerState>();

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
    setState(() {
      close = false;
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: SliderDrawer(
          key: _key,
          appBar: SliderAppBar(
            appBarHeight: 90,
          appBarPadding: EdgeInsets.symmetric(horizontal: 10),
          appBarColor: Colors.white,
          drawerIconSize: 50,
           title: Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
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
