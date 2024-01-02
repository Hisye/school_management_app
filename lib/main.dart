import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:school_management_app/widgets/add_student_dc.dart';
import './widgets/login_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hisye App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: AddStudentDC(),
    );
  }
}