import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:school_management_app/models/student.dart';
import 'package:school_management_app/models/teacher.dart';
import 'teacher_list_screen.dart';
import 'student_list_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:school_management_app/models/firebase_user.dart';

class DataList extends StatefulWidget {
  const DataList({Key? key}) : super(key: key);

  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  // final DatabaseReference _teacherRef =
  //     FirebaseDatabase.instance.ref().child('$adminPrefix/teacher-data');
  String adminPrefix = FirebaseHelper.getAdminPrefix();

  //int _teacherCount = 0;

  @override
  void initState() {
    super.initState();
    print('DataList initState');
    //_fetchTeacherCount();
    _loadDataTeacher();
    _loadDataStudent();
  }

  List<Teacher> _teacherList = [];

  void _loadDataTeacher() async {
    final url = Uri.https(
      'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/$adminPrefix/teacher-data.json',
    );
    final response = await http.get(url);
    print('#debug Lecturer-list.dart');
    print(response.body);
    final Map<String, dynamic> listData = json.decode(response.body);
    print('#debug Lecturer-list.dart');
    print(listData);
    final List<Teacher> _loadedData = [];
    for (final data in listData.entries) {
      _loadedData.add(
        Teacher(
          id: data.key,
          staffId: data.value['Staff ID'],
          fullName: data.value['Full Name'],
          faculty: data.value['Faculty'],
          subject: data.value['Subject'],
        ),
      );
    }

    setState(() {
      _teacherList = _loadedData;
      print('teacher list: ${_teacherList.length}');
    });
  }

  List<Student> _studentList = [];

  void _loadDataStudent() async {
    final url = Uri.https(
      'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/$adminPrefix/student-data.json',
    );
    final response = await http.get(url);
    print('#debug student-list.dart');
    print(response.body);
    final Map<String, dynamic> listData = json.decode(response.body);
    print('#debug student-list.dart');
    print(listData);
    final List<Student> _loadedData = [];
    for (final data in listData.entries) {
      _loadedData.add(
        Student(
          id: data.key,
          matricNo: data.value['Matric No'],
          fullName: data.value['Full Name'],
          course: data.value['Course'],
        ),
      );
    }

    setState(() {
      _studentList = _loadedData;
    });
  }

  // Future<void> _fetchTeacherCount() async {
  //   print('Fetching teacher count...');
  //   try {
  //     DatabaseEvent event = await _teacherRef.once();
  //     DataSnapshot dataSnapshot = event.snapshot;

  //     print('DataSnapshot key: ${dataSnapshot.key}');
  //     print('DataSnapshot value: ${dataSnapshot.value}');
  //     // print('DataSnapshot has children: ${dataSnapshot.hasChildren}');
  //     // print('DataSnapshot children count: ${dataSnapshot.childrenCount}');

  //     if (dataSnapshot.value != null) {
  //       // Explicitly cast dataSnapshot.value to Map<String, dynamic>
  //       Map<String, dynamic> data =
  //           (dataSnapshot.value as Map<String, dynamic>);

  //       setState(() {
  //         _teacherCount = data.length;
  //       });

  //       // Print the data for debugging purposes
  //       print('Fetched data: $data');
  //     } else {
  //       print('No data available.');
  //     }
  //   } catch (error) {
  //     print('Error fetching data: $error');
  //   }
  // }

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TeacherListScreen(),
                ),
              );
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
                          'Teacher Data List',
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
                          'Amount of Data: ${_teacherList.length}', // Replace X with the actual amount
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
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
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentListScreen(),
                ),
              );
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
                          'Student Data List',
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
                          'Amount of Data: ${_studentList.length}', // Replace X with the actual amount
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
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
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentListScreen(),
                ),
              );
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
                          'Discipline Case List',
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
