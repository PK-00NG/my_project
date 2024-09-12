import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'เมนูการตั้งค่า',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown),
                ),
              ),
              _buildMenuItem('นายธนเดช', 'Test123@gmail.com', Icons.person),
              _buildMenuItem('หน่วยวัดน้ำหนัก', 'กิโลกรัม', Icons.balance,
                  showArrow: true),
              _buildMenuItem('หน่วยวัดความยาว', 'เซนติเมตร', Icons.straighten,
                  showArrow: true),
              // เพิ่ม SizedBox แทนรูปภาพเพื่อให้มีพื้นที่ว่าง
              SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, String subtitle, IconData icon,
      {bool showArrow = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.brown),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: showArrow ? Icon(Icons.arrow_forward_ios, size: 16) : null,
      ),
    );
  }
}
