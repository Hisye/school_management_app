import 'package:flutter/material.dart';
import 'package:school_management_app/models/student.dart';
import 'package:school_management_app/widgets/add_student_dc.dart';
import 'package:school_management_app/widgets/add_student_result.dart';

class StudentInfo extends StatelessWidget {
  final Student student;

  const StudentInfo({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Info'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.add),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onSelected: (value) {
              if (value == 'AddResult') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddStudentResult(),
                  ),
                );
              } else if (value == 'AddDisciplineCase') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddStudentDC(),
                  ),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'AddResult',
                child: Text('Add Result'),
              ),
              const PopupMenuItem<String>(
                value: 'AddDisciplineCase',
                child: Text('Add Discipline Case'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Full Name:', student.fullName),
            _buildInfoRow('Matrix Number:', student.matricNo),
            _buildInfoRow('Course:', student.course),
            _buildInfoRow('Discipline Case:', "null"),
            _buildInfoRow('Result', "null")
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
