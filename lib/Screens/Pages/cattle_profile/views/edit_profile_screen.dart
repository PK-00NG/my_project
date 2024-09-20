import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_project/Screens/Widgets/background_widget.dart';
import 'package:flutter/services.dart';

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
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, ValueNotifier<bool>> _highlightNotifiers = {};

  // Define colors
  final Color _inactiveColor = const Color(0xFFE8E8E8);
  final Color _activeColor = Colors.white;
  final Color _borderColor = Colors.brown;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _selectedDate =
        DateTime.tryParse(widget.profileData['วัน/เดือน/ปีเกิด'] ?? '');
    _initializeFocusNodesAndNotifiers();
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

  void _initializeFocusNodesAndNotifiers() {
    _controllers.keys.forEach((field) {
      _focusNodes[field] = FocusNode();
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

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    _focusNodes.values.forEach((node) {
      node.removeListener(() {});
      node.dispose();
    });
    _highlightNotifiers.values.forEach((notifier) => notifier.dispose());
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

  static const TextStyle _buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text("แก้ไขโปรไฟล์", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF7B3113).withOpacity(0.7),
                    Color(0xFF7B3113).withOpacity(0.0),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: BackgroundWidget(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ElevatedButton(
                            child:
                                const Text('บันทึก', style: _buttonTextStyle),
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
          ),
        ));
  }

  Widget _buildTextField(String label) {
    return ValueListenableBuilder<bool>(
      valueListenable: _highlightNotifiers[label]!,
      builder: (context, shouldHighlight, child) {
        return TextFormField(
          controller: _controllers[label],
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
          validator: (value) => value!.isEmpty ? 'กรุณากรอก$label' : null,
        );
      },
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return ValueListenableBuilder<bool>(
      valueListenable: _highlightNotifiers[label]!,
      builder: (context, shouldHighlight, _) {
        return DropdownButtonFormField<String>(
          value: _controllers[label]!.text,
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
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _controllers[label]!.text = value ?? '';
            });
          },
          validator: (value) => value == null ? 'กรุณาเลือก$label' : null,
        );
      },
    );
  }

  Widget _buildDateField() {
    return ValueListenableBuilder<bool>(
      valueListenable: _highlightNotifiers['วัน/เดือน/ปีเกิด']!,
      builder: (context, shouldHighlight, child) {
        return TextFormField(
          controller: _controllers['วัน/เดือน/ปีเกิด'],
          focusNode: _focusNodes['วัน/เดือน/ปีเกิด'],
          decoration: InputDecoration(
            labelText: 'วัน/เดือน/ปีเกิด',
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
            suffixIcon: Icon(Icons.calendar_today),
          ),
          readOnly: true,
          onTap: () => _selectDate(context),
          validator: (value) =>
              value!.isEmpty ? 'กรุณาเลือกวันเดือนปีเกิด' : null,
        );
      },
    );
  }
}
