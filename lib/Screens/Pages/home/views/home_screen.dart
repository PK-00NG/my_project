import 'package:flutter/material.dart';
import 'package:my_project/Screens/Pages/cattle_profile/views/cattle_profile_screen.dart';

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
  late List<Map<String, dynamic>> _profiles;

  final Color _inactiveColor = const Color(0xFFE8E8E8);
  final Color _activeColor = Colors.white;
  final Color _borderColor = const Color(0xFFD2B48C);

  List<Map<String, dynamic>> _getFilteredProfiles() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      return _profiles;
    }
    return _profiles.where((profile) {
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
    _profiles = List.from(widget.profiles);
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
      TextStyle(fontSize: 18, color: Color(0xFF7B3113));

  void _openCattleProfile(int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CattleProfileScreen(
          profileData: _profiles[index],
          onUpdate: (updatedProfile) {
            setState(() {
              _profiles[index] = updatedProfile;
            });
          },
          onDelete: () {
            setState(() {
              _profiles.removeAt(index);
            });
          },
        ),
      ),
    );

    if (result == true) {
      // โปรไฟล์ถูกลบ, อัปเดต UI
      setState(() {
        // ไม่ต้องทำอะไรเพิ่มเติม เพราะ onDelete ได้ลบโปรไฟล์ออกจาก _profiles แล้ว
      });
    }
  }

  void updateProfiles(List<Map<String, dynamic>> newProfiles) {
    setState(() {
      _profiles = newProfiles;
    });
  }

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
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, searchValue, _) {
                if (_profiles.isEmpty) {
                  // ใช้ _profiles แทน widget.profiles
                  return const Center(
                      child: Text('     ไม่มีโปรไฟล์โค\nกรุณาเพิ่มโปรไฟล์โค',
                          style: _messageStyle));
                }
                final filteredProfiles = _getFilteredProfiles();
                return filteredProfiles.isEmpty
                    ? const Center(
                        child: Text('ไม่พบโปรไฟล์', style: _messageStyle))
                    : ListView.builder(
                        itemCount: filteredProfiles.length,
                        itemBuilder: (context, index) {
                          return _buildProfileCard(filteredProfiles[index]);
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profile) {
    final index = _profiles.indexOf(profile);
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
        onTap: () => _openCattleProfile(index),
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
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: _borderColor, width: 1),
        ),
      ),
    );
  }
}
