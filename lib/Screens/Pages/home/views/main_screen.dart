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

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    AddProfileScreen(),
    MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // _buildBackground(context),
          _screens[_currentIndex],
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            _buildCircle(20, -1.2, 1, Theme.of(context).colorScheme.tertiary),
            _buildCircle(
                -2.7, -1.2, 1.3, Theme.of(context).colorScheme.secondary),
            _buildCircle(
                2.7, -1.2, 1.3, Theme.of(context).colorScheme.secondary),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
              child: Container(),
            ),
          ],
        ),
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
        border: Border(
          top: BorderSide(
            color: Color(0xFFD2B48C),
            width: 2.0,
          ),
        ),
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
