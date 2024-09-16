import 'package:flutter/material.dart';
import 'package:my_project/Screens/Pages/cattle_profile/views/edit_profile_screen.dart';
import 'package:my_project/Screens/Widgets/background_widget.dart';

class CattleProfileScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;
  final Function(Map<String, dynamic>) onUpdate;
  final Function() onDelete;

  const CattleProfileScreen({
    Key? key,
    required this.profileData,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  _CattleProfileScreenState createState() => _CattleProfileScreenState();
}

class _CattleProfileScreenState extends State<CattleProfileScreen> {
  late Map<String, dynamic> _profileData;

  @override
  void initState() {
    super.initState();
    _profileData = Map.from(widget.profileData);
  }

  void _editProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          profileData: _profileData,
          onSave: (updatedProfile) {
            setState(() {
              _profileData = updatedProfile;
            });
            widget.onUpdate(updatedProfile);
          },
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _profileData = result;
      });
    }
  }

  void _deleteProfile() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("ยืนยันการลบ"),
          content: Text("คุณแน่ใจหรือไม่ที่จะลบโปรไฟล์นี้?"),
          actions: [
            TextButton(
              child: Text("ยกเลิก"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("ลบ"),
              onPressed: () {
                Navigator.of(context).pop(); // ปิด dialog
                widget
                    .onDelete(); // เรียกใช้ฟังก์ชัน onDelete ที่ส่งมาจาก HomeScreen
                Navigator.of(context).pop(
                    true); // ส่งค่า true กลับไปยัง HomeScreen เพื่อบอกว่ามีการลบ
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("รายละเอียดโค", style: TextStyle(color: Colors.brown)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart, color: Colors.brown),
            onPressed: () {
              // TODO: Implement statistics functionality
            },
          ),
          _buildOptionsDropdown(context),
        ],
      ),
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildProfileHeader(),
                  SizedBox(height: 16),
                  _buildDetailsCard(),
                  SizedBox(height: 24),
                  _buildWeightEstimationButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            // TODO: Replace with actual image when available
            // child: Icon(Icons.cow, size: 100, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _profileData['ชื่อโค'] ?? 'ไม่ระบุชื่อ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8),
              Icon(
                _profileData['เพศ'] == 'เมีย' ? Icons.female : Icons.male,
                color:
                    _profileData['เพศ'] == 'เมีย' ? Colors.pink : Colors.blue,
              ),
            ],
          ),
          Text(
            'น้ำหนัก: ${_profileData['น้ำหนัก'] ?? '???'} KG',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('หมายเลขโค', _profileData['หมายเลขโค']),
            _buildDetailRow('สายพันธุ์', _profileData['สายพันธุ์']),
            _buildDetailRow('สี', _profileData['สีตัวโค']),
            _buildDetailRow('วันที่เกิด', _profileData['วัน/เดือน/ปีเกิด']),
            _buildDetailRow(
                'หมายเลขพ่อพันธุ์', _profileData['หมายเลขพ่อพันธุ์']),
            _buildDetailRow(
                'หมายเลขแม่พันธุ์', _profileData['หมายเลขแม่พันธุ์']),
            _buildDetailRow('ชื่อผู้เลี้ยง', _profileData['ชื่อผู้เลี้ยง']),
            _buildDetailRow(
                'เจ้าของในปัจจุบัน', _profileData['ชื่อเจ้าของในปัจจุบัน']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value ?? 'ไม่ระบุ'),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightEstimationButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8, // ปรับความกว้างตามต้องการ
      child: ElevatedButton.icon(
        icon: Icon(Icons.scale, color: Colors.white),
        label: Text(
          'ประเมินน้ำหนักโค',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          // TODO: Implement weight estimation
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.brown,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsDropdown(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.brown),
      onSelected: (String result) {
        switch (result) {
          case 'edit':
            _editProfile();
            break;
          case 'delete':
            _deleteProfile();
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('แก้ไข'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('ลบ'),
          ),
        ),
      ],
    );
  }
}
