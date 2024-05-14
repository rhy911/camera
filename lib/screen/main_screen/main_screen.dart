import 'package:Camera/screen/main_screen/tabs/add.dart';
import 'package:Camera/screen/main_screen/tabs/home.dart';
import 'package:Camera/screen/main_screen/tabs/gallery.dart';
import 'package:Camera/screen/main_screen/tabs/profile.dart';
import 'package:Camera/screen/main_screen/tabs/search.dart';
import 'package:Camera/themes/app_color.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _widgetOptions = <Widget>[
    const Home(),
    const Library(),
    const AddWidget(),
    const Search(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBody: true,
        body: _widgetOptions[_selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
          height: 75.0,
          backgroundColor: Colors.transparent,
          color: Theme.of(context).primaryColor,
          index: _selectedIndex,
          onTap: navigateBottomBar,
          items: [
            const Icon(Icons.home),
            const Icon(Icons.photo_library),
            CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).primaryColor,
                child: const Icon(Icons.add,
                    size: 50, color: AppColor.vibrantColor)),
            const Icon(Icons.search),
            const Icon(Icons.person),
          ],
          animationDuration: const Duration(milliseconds: 300),
          animationCurve: Curves.easeInOut,
        ),
      ),
    );
  }
}
