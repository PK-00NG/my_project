import 'package:flutter/material.dart';

class AddProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มโปรไฟล์'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
                decoration: InputDecoration(
                    labelText: 'ชื่อโค', border: OutlineInputBorder())),
            SizedBox(height: 16),
            TextField(
                decoration: InputDecoration(
                    labelText: 'หมายเลขโค', border: OutlineInputBorder())),
            SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: InputDecoration(
                  labelText: 'เพศโค', border: OutlineInputBorder()),
              items: [], // Add items here
              onChanged: (value) {},
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                        labelText: 'วัน/เดือน/ปีเกิด',
                        border: OutlineInputBorder()),
                    items: [], // Add items here
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(width: 16),
                IconButton(icon: Icon(Icons.calendar_today), onPressed: () {}),
              ],
            ),
            SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: InputDecoration(
                  labelText: 'สายพันธุ์', border: OutlineInputBorder()),
              items: [], // Add items here
              onChanged: (value) {},
            ),
            SizedBox(height: 16),
            TextField(
                decoration: InputDecoration(
                    labelText: 'น้ำหนัก', border: OutlineInputBorder())),
            SizedBox(height: 16),
            TextField(
                decoration: InputDecoration(
                    labelText: 'หมายเลขพ่อพันธุ์',
                    border: OutlineInputBorder())),
            SizedBox(height: 16),
            TextField(
                decoration: InputDecoration(
                    labelText: 'หมายเลขแม่พันธุ์',
                    border: OutlineInputBorder())),
            SizedBox(height: 16),
            TextField(
                decoration: InputDecoration(
                    labelText: 'รายละเอียดอื่นๆ',
                    border: OutlineInputBorder())),
            SizedBox(height: 24),
            ElevatedButton(
              child: Text('บันทึก'),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFFFFF0E0),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าหลัก'),
          BottomNavigationBarItem(
              icon: Icon(Icons.article), label: 'เมนูอื่นๆ'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'โปรไฟล์'),
        ],
        currentIndex: 1,
      ),
    );
  }
}
