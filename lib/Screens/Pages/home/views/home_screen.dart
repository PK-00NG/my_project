import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  // Define colors
  final Color _inactiveColor = const Color(0xFFE8E8E8);
  final Color _activeColor = Colors.white;
  final Color _borderColor = const Color(0xFFD2B48C);

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() {
      setState(() {}); // Rebuild when focus changes
    });
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSearchField(),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'ยังไม่มีโปรไฟล์',
                    style: TextStyle(fontSize: 18, color: Color(0xFFD2B48C)),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'กรุณาเพิ่มโปรไฟล์',
                    style: TextStyle(fontSize: 18, color: Color(0xFFD2B48C)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    bool shouldHighlight =
        _searchFocus.hasFocus || _searchController.text.isNotEmpty;
    return TextField(
      focusNode: _searchFocus,
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'ชื่อโค / หมายเลข ID',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: shouldHighlight ? _activeColor : _inactiveColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: shouldHighlight
              ? BorderSide(color: _borderColor, width: 1)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: _borderColor, width: 1),
        ),
      ),
      onChanged: (value) {
        setState(() {}); // Trigger rebuild to update colors
      },
    );
  }
}
