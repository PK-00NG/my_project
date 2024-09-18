import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:my_project/Screens/Widgets/background_widget.dart';
import 'home_screen.dart';
import 'add_profile_screen.dart';
import 'menu_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

enum BottomNavItem { home, addProfile, menu }

const BorderSide _topBorder = BorderSide(
  color: Color(0xFFD2B48C),
  width: 2.0,
);

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> _profiles = [];
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _updateScreens();
  }

  void _updateScreens() {
    _screens = [
      HomeScreen(profiles: _profiles),
      AddProfileScreen(onSave: _handleProfileSave),
      const MenuScreen(),
    ];
  }

  void _handleProfileSave(Map<String, dynamic> newProfile) {
    setState(() {
      _profiles.add(newProfile);
      _currentIndex = 0; // Switch to HomeScreen
      _updateScreens();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundWidget(
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: _topBorder),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าหลัก'),
          BottomNavigationBarItem(
              icon: Icon(Icons.article), label: 'เพิ่มโปรไฟล์'),
          BottomNavigationBarItem(
              icon: Icon(Icons.manage_accounts_rounded), label: 'ฉัน'),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        elevation: 0,
      ),
    );
  }
}
