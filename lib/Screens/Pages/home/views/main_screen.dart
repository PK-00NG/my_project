import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'add_profile_screen.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Align(
                    alignment: const AlignmentDirectional(20, -1.2),
                    child: Container(
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(-2.7, -1.2),
                    child: Container(
                      height: MediaQuery.of(context).size.width / 1.3,
                      width: MediaQuery.of(context).size.width / 1.3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  Align(
                    alignment: const AlignmentDirectional(2.7, -1.2),
                    child: Container(
                      height: MediaQuery.of(context).size.width / 1.3,
                      width: MediaQuery.of(context).size.width / 1.3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
          // Content
          _screens[_currentIndex],
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
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
          elevation: 0,
        ),
      ),
    );
  }
}
