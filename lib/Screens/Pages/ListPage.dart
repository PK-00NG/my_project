import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.settings)),
            Tab(icon: Icon(Icons.add))
          ]),
          title: Center(
            child: Text('Cattle List'),
          ),
        ),
        body: TabBarView(children: [
          Container(color: Colors.lightBlue, child: Text("Cattle Profile")),
          Container(color: Colors.lightGreen, child: Text("Setting")),
          Container(color: Colors.lime, child: Text("Add Cattle Profile"))
        ]),
      ),
    );
  }
}
