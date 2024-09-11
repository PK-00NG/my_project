import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddProfileScreen extends StatefulWidget {
  const AddProfileScreen({Key? key}) : super(key: key);

  @override
  _AddProfileScreenState createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, TextEditingController> _controllers = {};

  // Define colors
  final Color _inactiveColor = Colors.grey[200]!;
  final Color _activeColor = Colors.white;
  final Color _borderColor = Colors.brown;

  @override
  void initState() {
    super.initState();
    // Initialize focus nodes and controllers for each field
    [
      'ชื่อโค',
      'หมายเลขโค',
      'เพศ',
      'วัน/เดือน/ปีเกิด',
      'สายพันธุ์',
      'สีตัวโค',
      'หมายเลขพ่อพันธุ์',
      'หมายเลขแม่พันธุ์',
      'ชื่อผู้เลี้ยง',
      'ชื่อเจ้าของในปัจจุบัน'
    ].forEach((field) {
      _focusNodes[field] = FocusNode();
      _controllers[field] = TextEditingController();
      _focusNodes[field]!.addListener(() {
        setState(() {}); // Rebuild when focus changes
      });
    });
  }

  @override
  void dispose() {
    // Dispose all focus nodes and controllers
    _focusNodes.values.forEach((node) {
      node.removeListener(() {});
      node.dispose();
    });
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'เพิ่มโปรไฟล์',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildTextField('ชื่อโค'),
                const SizedBox(height: 16),
                _buildTextField('หมายเลขโค'),
                const SizedBox(height: 16),
                _buildDropdownField('เพศ', ['ผู้', 'เมีย']),
                const SizedBox(height: 16),
                _buildDateField(),
                const SizedBox(height: 16),
                _buildDropdownField('สายพันธุ์', ['บราห์มัน', 'ชาโรเลส์']),
                const SizedBox(height: 16),
                _buildTextField('สีตัวโค'),
                const SizedBox(height: 16),
                _buildTextField('หมายเลขพ่อพันธุ์'),
                const SizedBox(height: 16),
                _buildTextField('หมายเลขแม่พันธุ์'),
                const SizedBox(height: 16),
                _buildTextField('ชื่อผู้เลี้ยง'),
                const SizedBox(height: 16),
                _buildTextField('ชื่อเจ้าของในปัจจุบัน'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text(
                      'บันทึก',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: Save the form data
                        // Navigate back or show confirmation
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(
      focusNode: _focusNodes[label],
      controller: _controllers[label],
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: _shouldHighlight(label) ? _activeColor : _inactiveColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: _shouldHighlight(label)
              ? BorderSide(color: _borderColor, width: 1)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _borderColor, width: 1),
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: (value) {
        setState(() {}); // Trigger rebuild to update colors
      },
      style: TextStyle(color: Colors.black),
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return DropdownButtonFormField<String>(
      focusNode: _focusNodes[label],
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: _shouldHighlight(label) ? _activeColor : _inactiveColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: _shouldHighlight(label)
              ? BorderSide(color: _borderColor, width: 1)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _borderColor, width: 1),
        ),
      ),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _controllers[label]!.text = value ?? '';
        });
      },
      style: TextStyle(color: Colors.black),
    );
  }

  Widget _buildDateField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            focusNode: _focusNodes['วัน/เดือน/ปีเกิด'],
            controller: _controllers['วัน/เดือน/ปีเกิด'],
            decoration: InputDecoration(
              labelText: 'วัน/เดือน/ปีเกิด',
              filled: true,
              fillColor: _shouldHighlight('วัน/เดือน/ปีเกิด')
                  ? _activeColor
                  : _inactiveColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: _shouldHighlight('วัน/เดือน/ปีเกิด')
                    ? BorderSide(color: _borderColor, width: 1)
                    : BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _borderColor, width: 1),
              ),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _selectDate(context),
        ),
      ],
    );
  }

  bool _shouldHighlight(String label) {
    return _focusNodes[label]!.hasFocus || _controllers[label]!.text.isNotEmpty;
  }
}
