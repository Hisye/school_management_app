import 'package:flutter/material.dart';
import 'package:school_management_app/widgets/add_lecturer_screen.dart';
import 'package:school_management_app/widgets/add_student_screen.dart';
import 'package:school_management_app/widgets/dashboard_list_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
      ),
      body: DataList(),
      drawer: DrawerWidget(),
    );
  }
}

class DrawerWidget extends StatefulWidget {

  DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String logo = 'images/umt_logo.png';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.purple,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 90,
                    width: 90,
                    child: Image.asset(logo),
                  ),
                ),
                const Text(
                  'UMT Management App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Add Lecturer'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LecturerDataEntry(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Add Student'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentDataEntry(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
