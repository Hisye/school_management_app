import 'package:flutter/material.dart';
import 'package:school_management_app/models/teacher.dart';
import 'package:school_management_app/widgets/edit/edit_teacher_data.dart';

class TeacherInfo extends StatelessWidget {
  final Teacher teacher;

  const TeacherInfo({Key? key, required this.teacher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Info'),
        actions: [
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onSelected: (value) {
              if (value == 'EditTeacherData') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditTeacherData(
                      teacher: teacher,
                    ),
                  ),
                );
              } 
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'EditTeacherData',
                child: Text('Edit Teacher Data'),
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
            _buildInfoRow('Full Name:', teacher.fullName),
            _buildInfoRow('Staff ID:', teacher.staffId),
            _buildInfoRow('Faculty:', teacher.faculty),
            _buildInfoRow('Subject:', teacher.subject),
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
