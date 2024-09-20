import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddProfileScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const AddProfileScreen({Key? key, required this.onSave}) : super(key: key);

  @override
  _AddProfileScreenState createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, TextEditingController> _controllers = {};

  // Define colors
  final Color _inactiveColor = const Color(0xFFE8E8E8);
  final Color _activeColor = Colors.white;
  final Color _borderColor = Colors.brown;

  final Map<String, ValueNotifier<bool>> _highlightNotifiers = {};

  @override
  void initState() {
    super.initState();
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
      _highlightNotifiers[field] = ValueNotifier<bool>(false);
      _focusNodes[field]!.addListener(() {
        _updateHighlight(field);
      });
      _controllers[field]!.addListener(() {
        _updateHighlight(field);
      });
    });
  }

  void _updateHighlight(String field) {
    if (mounted) {
      setState(() {
        _highlightNotifiers[field]!.value = _focusNodes[field]!.hasFocus ||
            _controllers[field]!.text.isNotEmpty;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final profileData = {
        'ชื่อโค': _controllers['ชื่อโค']!.text,
        'หมายเลขโค': _controllers['หมายเลขโค']!.text,
        'เพศ': _controllers['เพศ']!.text,
        'วัน/เดือน/ปีเกิด': _controllers['วัน/เดือน/ปีเกิด']!.text,
        'สายพันธุ์': _controllers['สายพันธุ์']!.text,
        'สีตัวโค': _controllers['สีตัวโค']!.text,
        'หมายเลขพ่อพันธุ์': _controllers['หมายเลขพ่อพันธุ์']!.text,
        'หมายเลขแม่พันธุ์': _controllers['หมายเลขแม่พันธุ์']!.text,
        'ชื่อผู้เลี้ยง': _controllers['ชื่อผู้เลี้ยง']!.text,
        'ชื่อเจ้าของในปัจจุบัน': _controllers['ชื่อเจ้าของในปัจจุบัน']!.text,
      };
      widget.onSave(profileData);
    }
  }

  @override
  void dispose() {
    // Dispose all focus nodes and controllers
    _focusNodes.values.forEach((node) {
      node.removeListener(() {});
      node.dispose();
    });
    _highlightNotifiers.values.forEach((notifier) => notifier.dispose());
    super.dispose();
  }

  static const TextStyle _titleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle _buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

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
                const Text('เพิ่มโปรไฟล์', style: _titleStyle),
                const SizedBox(height: 16),
                _buildTextField('ชื่อโค'),
                const SizedBox(height: 16),
                _buildTextField('หมายเลขโค'),
                const SizedBox(height: 16),
                _buildDropdownField('เพศ', ['ผู้', 'เมีย']),
                const SizedBox(height: 16),
                _buildDateField(),
                const SizedBox(height: 16),
                _buildDropdownField(
                    'สายพันธุ์', ['บราห์มัน', 'ชาโรเลส์', 'บีฟมาสเตอร์']),
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
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      child: const Text('บันทึก', style: _buttonTextStyle),
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7B3113),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
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
    return ValueListenableBuilder<bool>(
      valueListenable: _highlightNotifiers[label]!,
      builder: (context, shouldHighlight, child) {
        return TextFormField(
          focusNode: _focusNodes[label],
          controller: _controllers[label],
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: shouldHighlight ? _activeColor : _inactiveColor,
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
            _updateHighlight(label);
          },
          style: TextStyle(color: Colors.black),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณากรอก$label';
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return ValueListenableBuilder<bool>(
      valueListenable: _highlightNotifiers[label]!,
      builder: (context, shouldHighlight, _) {
        return DropdownButtonFormField<String>(
          value: _controllers[label]!.text.isNotEmpty
              ? _controllers[label]!.text
              : null,
          focusNode: _focusNodes[label],
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: shouldHighlight ? _activeColor : _inactiveColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: shouldHighlight
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
              _updateHighlight(label);
            });
          },
          style: TextStyle(color: Colors.black),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณาเลือก$label';
            }
            return null;
          },
        );
      },
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณาเลือกวันเดือนปีเกิด';
              }
              return null;
            },
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
