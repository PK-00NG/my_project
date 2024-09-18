import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/blocs/sign_in/sign_in_bloc.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final ValueNotifier<String?> _selectedWeightUnit = ValueNotifier('กิโลกรัม');
  final ValueNotifier<String?> _selectedLengthUnit = ValueNotifier('เซนติเมตร');
  final ValueNotifier<File?> _image = ValueNotifier(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _image.value = File(pickedFile.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการเลือกรูปภาพ')),
      );
    }
  }

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 28, // เพิ่มขนาดตัวอักษร
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle _contentStyle = TextStyle(
    fontSize: 18, // เพิ่มขนาดตัวอักษรสำหรับเนื้อหา
  );

  static const EdgeInsets _cardMargin =
      EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  void _showSignOutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการออกจากระบบ', style: TextStyle(fontSize: 22)),
          content: Text('คุณต้องการออกจากระบบใช่หรือไม่?',
              style: TextStyle(fontSize: 18)),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ยืนยัน', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Navigator.of(context).pop();
                _signOut();
              },
            ),
          ],
        );
      },
    );
  }

  void _signOut() {
    context.read<SignInBloc>().add(SignOutRequired());
    // TODO: เพิ่มโค้ดสำหรับนำผู้ใช้ไปยังหน้า login หรือหน้าอื่นๆ ตามที่ต้องการ
    print("ออกจากระบบสำเร็จ");
  }

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
                child: Text('เมนูการตั้งค่า', style: _titleStyle),
              ),
              _buildExpandableUserInfo(),
              _buildExpandableDropdown(
                'หน่วยวัดน้ำหนัก',
                ['กิโลกรัม', 'ปอนด์'],
                _selectedWeightUnit,
                icon: Icons.balance,
              ),
              _buildExpandableDropdown(
                'หน่วยวัดความยาว',
                ['เซนติเมตร', 'นิ้ว'],
                _selectedLengthUnit,
                icon: Icons.straighten,
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: _showSignOutConfirmation,
                    child: Text('ออกจากระบบ', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableUserInfo() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(
            horizontal: 16, vertical: 8), // เพิ่ม padding ด้านบนและล่าง
        leading: GestureDetector(
          onTap: _getImage,
          child: ValueListenableBuilder<File?>(
            valueListenable: _image,
            builder: (context, image, child) {
              return CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[200],
                backgroundImage: image != null ? FileImage(image) : null,
                child: image == null
                    ? Icon(Icons.add_a_photo, color: Colors.grey[800], size: 30)
                    : null,
              );
            },
          ),
        ),
        title: Text('นายธนเดช', style: _contentStyle),
        subtitle: Text('แตะเพื่อดูข้อมูลเพิ่มเติม',
            style: TextStyle(fontSize: 14)), // เพิ่ม subtitle
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ข้อมูลเพิ่มเติม:', style: _contentStyle),
                const SizedBox(height: 8),
                Text('เลขประจำตัวสหกรณ์: 1234567890', style: _contentStyle),
                Text(
                    'ที่อยู่: 123 ถนนเกษตร แขวงลาดยาว เขตจตุจักร กรุงเทพฯ 10900',
                    style: _contentStyle),
                Text('อีเมล: Test123@gmail.com', style: _contentStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableDropdown(
      String title, List<String> options, ValueNotifier<String?> selectedValue,
      {IconData? icon}) {
    return Card(
      margin: _cardMargin,
      child: ExpansionTile(
        leading:
            icon != null ? Icon(icon, color: Colors.brown, size: 24) : null,
        title: Text(title, style: _contentStyle),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ValueListenableBuilder<String?>(
              valueListenable: selectedValue,
              builder: (context, value, child) {
                return DropdownButton<String>(
                  isExpanded: true,
                  value: value,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      selectedValue.value = newValue;
                    }
                  },
                  items: options.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: _contentStyle),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
