import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> profiles;

  const HomeScreen({Key? key, required this.profiles}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FocusNode _searchFocus = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<bool> _shouldHighlight = ValueNotifier<bool>(false);

  // Define colors
  final Color _inactiveColor = const Color(0xFFE8E8E8);
  final Color _activeColor = Colors.white;
  final Color _borderColor = const Color(0xFFD2B48C);

  List<Map<String, dynamic>> _getFilteredProfiles() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      return widget.profiles;
    }
    return widget.profiles.where((profile) {
      final name = profile['ชื่อโค']?.toString().toLowerCase() ?? '';
      final id = profile['หมายเลขโค']?.toString().toLowerCase() ?? '';
      return name.contains(query) || id.contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(_updateHighlight);
    _searchController.addListener(_updateHighlight);
  }

  @override
  void dispose() {
    _searchFocus.removeListener(_updateHighlight);
    _searchController.removeListener(_updateHighlight);
    _searchFocus.dispose();
    _searchController.dispose();
    _shouldHighlight.dispose();
    super.dispose();
  }

  void _updateHighlight() {
    _shouldHighlight.value =
        _searchFocus.hasFocus || _searchController.text.isNotEmpty;
  }

  static const TextStyle _messageStyle =
      TextStyle(fontSize: 18, color: Color(0xFFD2B48C));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ValueListenableBuilder<bool>(
              valueListenable: _shouldHighlight,
              builder: (context, shouldHighlight, child) {
                return _buildSearchField(shouldHighlight);
              },
            ),
          ),
          Expanded(
            child: widget.profiles.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('ยังไม่มีโปรไฟล์', style: _messageStyle),
                        SizedBox(height: 8),
                        Text('กรุณาเพิ่มโปรไฟล์', style: _messageStyle),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.profiles.length,
                    itemBuilder: (context, index) {
                      return _buildProfileCard(widget.profiles[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profile) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(profile['ชื่อโค'] ?? 'ไม่มีชื่อ'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('หมายเลข: ${profile['หมายเลขโค'] ?? 'ไม่มีหมายเลข'}'),
            Text('เพศ: ${profile['เพศ'] ?? 'ไม่ระบุ'}'),
            Text('สายพันธุ์: ${profile['สายพันธุ์'] ?? 'ไม่ระบุ'}'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Widget _buildSearchField(bool shouldHighlight) {
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
    );
  }
}
