import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
              _buildUserInfoCard(),
              _buildDropdownField(
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
              _buildDropdownField(
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
              SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoCard() {
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
      ),
    );
  }

  Widget _buildDropdownField(String title, List<String> options,
      String? selectedValue, Function(String?) onChanged,
      {IconData? icon}) {
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
        leading: icon != null ? Icon(icon, color: Colors.brown) : null,
        title: Text(title),
        trailing: DropdownButton<String>(
          value: selectedValue,
          onChanged: onChanged,
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          underline: Container(),
        ),
      ),
    );
  }
}
