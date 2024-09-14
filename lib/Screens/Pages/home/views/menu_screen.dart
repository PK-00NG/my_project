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
  String? _selectedWeightUnit = 'กิโลกรัม';
  String? _selectedLengthUnit = 'เซนติเมตร';
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _showSignOutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('ยืนยันการออกจากระบบ'),
          content: Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิดหน้าต่างยืนยัน
              },
            ),
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิดหน้าต่างยืนยัน
                _signOut(); // เรียกใช้ฟังก์ชันออกจากระบบ
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
                child: Text(
                  'เมนูการตั้งค่า',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown),
                ),
              ),
              _buildExpandableUserInfo(),
              _buildExpandableDropdown(
                'หน่วยวัดน้ำหนัก',
                ['กิโลกรัม', 'ปอนด์'],
                _selectedWeightUnit,
                (value) {
                  setState(() {
                    _selectedWeightUnit = value;
                  });
                },
                icon: Icons.balance,
              ),
              _buildExpandableDropdown(
                'หน่วยวัดความยาว',
                ['เซนติเมตร', 'นิ้ว'],
                _selectedLengthUnit,
                (value) {
                  setState(() {
                    _selectedLengthUnit = value;
                  });
                },
                icon: Icons.straighten,
              ),
              SizedBox(height: 20),
              Center(
                // ใช้ Center เพื่อจัดตำแหน่งปุ่มให้อยู่กลาง
                child: SizedBox(
                  width: 200, // กำหนดความกว้างของปุ่มเป็น 200 พิกเซล
                  child: ElevatedButton(
                    onPressed: _showSignOutConfirmation,
                    child: Text('ออกจากระบบ'),
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
              SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandableUserInfo() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: GestureDetector(
          onTap: _getImage,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            backgroundImage: _image != null ? FileImage(_image!) : null,
            child: _image == null
                ? Icon(Icons.add_a_photo, color: Colors.grey[800])
                : null,
          ),
        ),
        title: Text('นายธนเดช'),
        subtitle: Text('Test123@gmail.com'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ข้อมูลเพิ่มเติม:'),
                SizedBox(height: 8),
                Text('ตำแหน่ง: ผู้จัดการฟาร์ม'),
                Text('เบอร์โทร: 081-234-5678'),
                // เพิ่มข้อมูลอื่นๆ ตามต้องการ
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableDropdown(String title, List<String> options,
      String? selectedValue, Function(String?) onChanged,
      {IconData? icon}) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: icon != null ? Icon(icon, color: Colors.brown) : null,
        title: Text(title),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              onChanged: onChanged,
              items: options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          // เพิ่มข้อมูลหรือตัวเลือกเพิ่มเติมตามต้องการ
        ],
      ),
    );
  }
}
