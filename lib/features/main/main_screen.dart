import 'package:Camera/features/main/add/presentation/pages/add.dart';
import 'package:Camera/features/main/gallery/presentation/pages/gallery.dart';
import 'package:Camera/features/main/discover/presentation/pages/discover.dart';
import 'package:Camera/features/main/profile/presentation/pages/profile.dart';
import 'package:Camera/features/main/search/presentation/pages/search.dart';
import 'package:Camera/config/themes/app_color.dart';
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
    const DiscoverPage(),
    const Search(),
    const AddWidget(),
    const Gallery(),
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
          color: Theme.of(context).scaffoldBackgroundColor,
          index: _selectedIndex,
          onTap: navigateBottomBar,
          items: const [
            Icon(Icons.home),
            Icon(Icons.search),
            Icon(Icons.add, size: 35, color: AppColor.vibrantColor),
            Icon(Icons.photo_library),
            Icon(Icons.person),
          ],
          animationDuration: const Duration(milliseconds: 300),
          animationCurve: Curves.easeInOut,
        ),
      ),
    );
  }
}
