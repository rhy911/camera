import 'package:Camera/features/main/presentation/pages/add.dart';
import 'package:Camera/features/main/presentation/pages/gallery.dart';
import 'package:Camera/features/main/presentation/pages/home.dart';
import 'package:Camera/features/main/presentation/pages/profile.dart';
import 'package:Camera/features/main/presentation/pages/search.dart';
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
    const HomePage(),
    const Search(),
    const AddWidget(),
    const Library(),
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
            const Icon(Icons.search),
            CircleAvatar(
                radius: 23,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: const Icon(Icons.add,
                    size: 30, color: AppColor.vibrantColor)),
            const Icon(Icons.photo_library),
            const Icon(Icons.person),
          ],
          animationDuration: const Duration(milliseconds: 300),
          animationCurve: Curves.easeInOut,
        ),
      ),
    );
  }
}
