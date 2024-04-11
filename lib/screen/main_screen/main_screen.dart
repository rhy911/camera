import 'package:Camera/screen/main_screen/tabs/add.dart';
import 'package:Camera/screen/main_screen/tabs/home.dart';
import 'package:Camera/screen/main_screen/tabs/library.dart';
import 'package:Camera/screen/main_screen/tabs/profile.dart';
import 'package:Camera/screen/main_screen/tabs/search.dart';
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
    const Add(),
    const Search(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 75.0,
        backgroundColor: Colors.white,
        color: const Color.fromARGB(255, 100, 56, 172),
        index: _selectedIndex,
        onTap: navigateBottomBar,
        items: [
          const Icon(Icons.home),
          const Icon(Icons.photo_library),
          CircleAvatar(
              radius: 30,
              child: Icon(Icons.add, size: 50, color: Colors.pinkAccent[100])),
          const Icon(Icons.search),
          const Icon(Icons.person),
        ],
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
      ),
    );
  }
}
