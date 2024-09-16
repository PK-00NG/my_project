import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_project/Screens/Widgets/background_widget.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;
  final Function(Map<String, dynamic>) onSave;

  const EditProfileScreen({
    Key? key,
    required this.profileData,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _selectedDate =
        DateTime.tryParse(widget.profileData['วัน/เดือน/ปีเกิด'] ?? '');
  }

  void _initializeControllers() {
    _controllers = {
      'ชื่อโค': TextEditingController(text: widget.profileData['ชื่อโค']),
      'หมายเลขโค': TextEditingController(text: widget.profileData['หมายเลขโค']),
      'เพศ': TextEditingController(text: widget.profileData['เพศ']),
      'วัน/เดือน/ปีเกิด':
          TextEditingController(text: widget.profileData['วัน/เดือน/ปีเกิด']),
      'สายพันธุ์': TextEditingController(text: widget.profileData['สายพันธุ์']),
      'สีตัวโค': TextEditingController(text: widget.profileData['สีตัวโค']),
      'หมายเลขพ่อพันธุ์':
          TextEditingController(text: widget.profileData['หมายเลขพ่อพันธุ์']),
      'หมายเลขแม่พันธุ์':
          TextEditingController(text: widget.profileData['หมายเลขแม่พันธุ์']),
      'ชื่อผู้เลี้ยง':
          TextEditingController(text: widget.profileData['ชื่อผู้เลี้ยง']),
      'ชื่อเจ้าของในปัจจุบัน': TextEditingController(
          text: widget.profileData['ชื่อเจ้าของในปัจจุบัน']),
    };
  }

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedProfile =
          _controllers.map((key, value) => MapEntry(key, value.text));
      widget.onSave(updatedProfile);
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controllers['วัน/เดือน/ปีเกิด']!.text =
            DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("แก้ไขโปรไฟล์", style: TextStyle(color: Colors.brown)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField('ชื่อโค'),
                  SizedBox(height: 16),
                  _buildTextField('หมายเลขโค'),
                  SizedBox(height: 16),
                  _buildDropdownField('เพศ', ['ผู้', 'เมีย']),
                  SizedBox(height: 16),
                  _buildDateField(),
                  SizedBox(height: 16),
                  _buildDropdownField(
                      'สายพันธุ์', ['บราห์มัน', 'ชาโรเลส์', 'บีฟมาสเตอร์']),
                  SizedBox(height: 16),
                  _buildTextField('สีตัวโค'),
                  SizedBox(height: 16),
                  _buildTextField('หมายเลขพ่อพันธุ์'),
                  SizedBox(height: 16),
                  _buildTextField('หมายเลขแม่พันธุ์'),
                  SizedBox(height: 16),
                  _buildTextField('ชื่อผู้เลี้ยง'),
                  SizedBox(height: 16),
                  _buildTextField('ชื่อเจ้าของในปัจจุบัน'),
                  SizedBox(height: 24),
                  ElevatedButton(
                    child: Text('บันทึก', style: TextStyle(fontSize: 18)),
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label) {
    return TextFormField(
      controller: _controllers[label],
      decoration: InputDecoration(labelText: label),
      validator: (value) => value!.isEmpty ? 'กรุณากรอก$label' : null,
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      value: _controllers[label]!.text,
      decoration: InputDecoration(labelText: label),
      items: items.map((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _controllers[label]!.text = value ?? '';
        });
      },
      validator: (value) => value == null ? 'กรุณาเลือก$label' : null,
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _controllers['วัน/เดือน/ปีเกิด'],
      decoration: InputDecoration(
        labelText: 'วัน/เดือน/ปีเกิด',
        suffixIcon: Icon(Icons.calendar_today),
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
      validator: (value) => value!.isEmpty ? 'กรุณาเลือกวันเดือนปีเกิด' : null,
    );
  }
}
