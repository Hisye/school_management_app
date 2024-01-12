import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:school_management_app/models/student.dart';
import 'package:school_management_app/models/student1.dart';
import 'package:school_management_app/models/student2.dart';
import 'package:school_management_app/models/teacher.dart';
import 'package:school_management_app/models/teacher1.dart';
import 'package:school_management_app/models/teacher2.dart';
import 'package:school_management_app/widgets/list_screen/dashboard_list_widget.dart';
import 'package:theme_provider/theme_provider.dart';

class KPMDashboardScreen extends StatefulWidget {
  const KPMDashboardScreen({super.key});

  @override
  State<KPMDashboardScreen> createState() => _KPMDashboardScreenState();
}

class _KPMDashboardScreenState extends State<KPMDashboardScreen> {
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.exit_to_app,
                size: 50,
                color: Colors.red,
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure you want to log out?',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                // Perform logout action here
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: false,
        actions: [
          ThemeConsumer(
            child: Builder(
              builder: (themeContext) => IconButton(
                onPressed: () {
                  ThemeProvider.controllerOf(context).nextTheme();
                  var currentTheme = ThemeProvider.themeOf(themeContext);

                  // Check the type of the current theme and switch the icon accordingly
                  if (currentTheme.id == AppTheme.dark().id) {
                    print('Switched to Dark Theme');
                    // You may update the logic based on your theme structure
                  } else {
                    print('Switched to Light Theme');
                    // You may update the logic based on your theme structure
                  }
                },
                icon: Icon(
                  ThemeProvider.themeOf(themeContext).id == AppTheme.dark().id
                      ? Icons.sunny
                      : Icons.dark_mode,
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: () => _showLogoutConfirmationDialog(context),
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: const KPMDataList(),
      // ),
    );
  }
}

class KPMDataList extends StatefulWidget {
  const KPMDataList({super.key});

  @override
  State<KPMDataList> createState() => _KPMDataListState();
}

class _KPMDataListState extends State<KPMDataList> {
  @override
  void initState() {
    super.initState();
    _loadDataStudentS1();
    _loadDataStudentS2();
    _loadDataTeacherS1();
    _loadDataTeacherS2();
  }
//load admin 01

  List<Teacher1> _teacherListS1 = [];

  void _loadDataTeacherS1() async {
    final url = Uri.https(
      'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/admin01/teacher-data.json',
    );
    final response = await http.get(url);
    print('#debug Lecturer-list.dart');
    print(response.body);
    final Map<String, dynamic> listData = json.decode(response.body);
    print('#debug Lecturer-list.dart');
    print(listData);
    final List<Teacher1> _loadedData = [];
    for (final data in listData.entries) {
      _loadedData.add(
        Teacher1(
          id: data.key,
          staffId: data.value['Staff ID'],
          fullName: data.value['Full Name'],
          faculty: data.value['Faculty'],
          subject: data.value['Subject'],
        ),
      );
    }

    setState(() {
      _teacherListS1 = _loadedData;
      print('teacher list: ${_teacherListS1.length}');
    });
  }

  List<Student1> _studentListS1 = [];

  void _loadDataStudentS1() async {
    final url = Uri.https(
      'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/admin01/student-data.json',
    );
    final response = await http.get(url);
    print('#debug student-list.dart');
    print(response.body);
    final Map<String, dynamic> listData = json.decode(response.body);
    print('#debug student-list.dart');
    print(listData);
    final List<Student1> _loadedData = [];
    for (final data in listData.entries) {
      _loadedData.add(
        Student1(
          id: data.key,
          matricNo: data.value['Matric No'],
          fullName: data.value['Full Name'],
          course: data.value['Course'],
        ),
      );
    }

    setState(() {
      _studentListS1 = _loadedData;
    });
  }

//load admin 02

  List<Teacher2> _teacherListS2 = [];

  void _loadDataTeacherS2() async {
    final url = Uri.https(
      'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/admin02/teacher-data.json',
    );
    final response = await http.get(url);
    print('#debug Lecturer-list.dart');
    print(response.body);
    final Map<String, dynamic> listData = json.decode(response.body);
    print('#debug Lecturer-list.dart');
    print(listData);
    final List<Teacher2> _loadedData = [];
    for (final data in listData.entries) {
      _loadedData.add(
        Teacher2(
          id: data.key,
          staffId: data.value['Staff ID'],
          fullName: data.value['Full Name'],
          faculty: data.value['Faculty'],
          subject: data.value['Subject'],
        ),
      );
    }

    setState(() {
      _teacherListS2 = _loadedData;
      print('teacher list: ${_teacherListS2.length}');
    });
  }

  List<Student2> _studentListS2 = [];

  void _loadDataStudentS2() async {
    final url = Uri.https(
      'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/admin02/student-data.json',
    );
    final response = await http.get(url);
    print('#debug student-list.dart');
    print(response.body);
    final Map<String, dynamic> listData = json.decode(response.body);
    print('#debug student-list.dart');
    print(listData);
    final List<Student2> _loadedData = [];
    for (final data in listData.entries) {
      _loadedData.add(
        Student2(
          id: data.key,
          matricNo: data.value['Matric No'],
          fullName: data.value['Full Name'],
          course: data.value['Course'],
        ),
      );
    }

    setState(() {
      _studentListS2 = _loadedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        //teacher widget
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => TeacherListScreen(),
              //   ),
              // );
            },
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SKBG',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        Row(
                          children: [
                            Text(
                              'Teacher: ${_teacherListS1.length}', // Replace X with the actual amount
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Student: ${_studentListS1.length}', // Replace X with the actual amount
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => StudentListScreen(),
              //   ),
              // );
            },
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple[200],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'SKKK',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        Row(
                          children: [
                            Text(
                              'Teacher: ${_teacherListS2.length}', // Replace X with the actual amount
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Student: ${_studentListS2.length}', // Replace X with the actual amount
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => StudentListScreen(),
              //   ),
              // );
            },
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple[300],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'School X',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 60,
                        ),
                        Text(
                          'Amount of Data: X', // Replace X with the actual amount
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
