import 'dart:ui';
import 'package:flutter/material.dart';
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
  late final List<Widget> _screens;
  final List<Map<String, dynamic>> _profiles = [];

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(profiles: _profiles),
      AddProfileScreen(onSave: _handleProfileSave),
      const MenuScreen(),
    ];
  }

  void _handleProfileSave(Map<String, dynamic> profileData) {
    setState(() {
      _profiles.add(profileData);
      _currentIndex = 0; // Switch to HomeScreen
      _screens[0] = HomeScreen(profiles: _profiles); // Update HomeScreen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildBackground(context),
          _screens[_currentIndex],
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          _buildCircle(20, -1.2, 1, Theme.of(context).colorScheme.tertiary),
          _buildCircle(
              -2.7, -1.2, 1.3, Theme.of(context).colorScheme.secondary),
          _buildCircle(2.7, -1.2, 1.3, Theme.of(context).colorScheme.secondary),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildCircle(
      double alignX, double alignY, double sizeDivisor, Color color) {
    return Align(
      alignment: AlignmentDirectional(alignX, alignY),
      child: Container(
        height: MediaQuery.of(context).size.width / sizeDivisor,
        width: MediaQuery.of(context).size.width / sizeDivisor,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
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
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'เมนู'),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        elevation: 0,
      ),
    );
  }
}
