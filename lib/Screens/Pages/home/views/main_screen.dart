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
  bool _showSnackBar = false;

  void _handleProfileSave(Map<String, dynamic> newProfile) {
    print("Saving new profile: $newProfile");
    setState(() {
      _profiles.add(newProfile);
      _currentIndex = 0;
      _showSnackBar = true;
    });
    print("Total profiles after save: ${_profiles.length}");
    // เพิ่มบรรทัดนี้เพื่อให้แน่ใจว่า HomeScreen ได้รับข้อมูลใหม่
    if (_currentIndex == 0) {
      _updateProfiles(_profiles);
    }
  }

  void _updateProfiles(List<Map<String, dynamic>> updatedProfiles) {
    setState(() {
      _profiles = updatedProfiles;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSnackBar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('บันทึกข้อมูลสำเร็จ')),
        );
        setState(() {
          _showSnackBar = false;
        });
      });
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          BackgroundWidget(
            child: Container(),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/cattle_logo.png',
                height: MediaQuery.of(context).size.height * 0.3,
                fit: BoxFit.contain,
              ),
            ),
          ),
          IndexedStack(
            index: _currentIndex,
            children: [
              HomeScreen(
                profiles: _profiles,
                onProfilesUpdated: (updatedProfiles) {
                  setState(() {
                    _profiles = updatedProfiles;
                  });
                },
              ),
              AddProfileScreen(onSave: _handleProfileSave),
              const MenuScreen(),
            ],
          ),
        ],
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
            if (index == 0) {
              // เมื่อกลับมาที่หน้า Home ให้อัปเดตข้อมูล
              _updateProfiles(_profiles);
            }
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
        selectedItemColor: Color(0xFF7B3113),
        unselectedItemColor: Colors.grey,
        elevation: 0,
      ),
    );
  }
}
