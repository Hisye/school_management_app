import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_management_app/models/discipline_case.dart';
import 'package:school_management_app/models/result.dart';
import 'package:school_management_app/models/student.dart';
import 'package:school_management_app/widgets/add/add_student_dc.dart';
import 'package:school_management_app/widgets/add/add_student_result.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_management_app/widgets/edit/edit_student_data.dart';
import 'package:school_management_app/widgets/edit/edit_student_dc.dart';
import 'package:school_management_app/models/firebase_user.dart';

class StudentInfo extends StatefulWidget {
  final Student student;

  StudentInfo({Key? key, required this.student}) : super(key: key);

  @override
  State<StudentInfo> createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  List<DisciplineCase> _disciplineCases = [];
  List<Result> _results = [];
  String adminPrefix = FirebaseHelper.getAdminPrefix();

  String extractDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd-MM-yyy').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    loadDataDC();
    _loadDataResult();
    
  }

  Future<void> loadDataDC() async {
    final url = Uri.https(
        'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/$adminPrefix/student-data/${widget.student.id}/discipline-case.json');

    final response = await http.get(url);
    final Map<String, dynamic> disciplineData = json.decode(response.body);

    if (disciplineData != null) {
      List<DisciplineCase> cases = [];
      for (final data in disciplineData.entries) {
        cases.add(DisciplineCase(
            id: data.key,
            disciplineType: data.value['Discipline Type'],
            description: data.value['Description'],
            date: data.value['Date']));
      }
      print(cases);

      setState(() {
        _disciplineCases.addAll(cases);
      });
    }
  }

  void _showDeleteDisciplineCaseDialog(DisciplineCase disciplineCase) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Discipline Case'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning,
                size: 50,
                color: Colors.red,
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure you want to delete this discipline case?',
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
                _deleteDisciplineCase(disciplineCase);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteDisciplineCase(DisciplineCase disciplineCase) async {
    final url = Uri.https(
      'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/$adminPrefix/student-data/${widget.student.id}/discipline-case/${disciplineCase.id}.json',
    );

    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // Successfully deleted discipline case
        loadDataDC(); // Reload data to reflect changes

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Discipline Case deleted successfully'),
          ),
        );
      } else {
        // Handle error
        print(
            'Failed to delete discipline case. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Error deleting discipline case: $error');

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot delete Discipline Case'),
        ),
      );
    }
  }

  Future<void> _loadDataResult() async {
    final url = Uri.https(
        'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/$adminPrefix/student-data/${widget.student.id}/result.json');

    final response = await http.get(url);
    final Map<String, dynamic> resultData = json.decode(response.body);

    if (resultData != null) {
      List<Result> results = [];
      for (final data in resultData.entries) {
        results.add(Result(
            id: data.key,
            subject: data.value['Subject'],
            grade: data.value['Grade']));
      }
      setState(() {
        _results = results;
      });
    }
  }

  void _navigateToAddStudentResult() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStudentResult(student: widget.student),
      ),
    );

    if (result == true) {
      // If a new result is added, reload the result data
      _loadDataResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Info'),
        actions: [
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onSelected: (value) {
              if (value == 'AddResult') {
                _navigateToAddStudentResult();
              } else if (value == 'AddDisciplineCase') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddStudentDC(
                      student: widget.student,
                    ),
                  ),
                );
              } else if (value == 'EditStudentData') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditStudentData(
                      student: widget.student,
                    ),
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
              const PopupMenuItem<String>(
                value: 'EditStudentData',
                child: Text('Edit Student Data'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildInfoRow('Full Name:', widget.student.fullName),
            _buildInfoRow('Matric Number:', widget.student.matricNo),
            _buildInfoRow('Course:', widget.student.course),
            _buildDisciplineCase(),
            _buildResults(),
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

  Widget _buildDisciplineCase() {
    if (_disciplineCases.isEmpty) {
      return _buildInfoRow('Discipline Cases:', 'None');
    } else {
      return Card(
        elevation: 3,
        color: Colors.red,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, bottom: 8, right: 94),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Discipline Cases:',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
              const SizedBox(height: 12),
              for (var disciplineCase in _disciplineCases)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white),
                    ),
                    child: ExpansionTile(
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white,
                      title: Text(
                        'Discipline Type: ${disciplineCase.disciplineType}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      subtitle:
                          Text('Date: ${extractDate(disciplineCase.date)}'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Description:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                disciplineCase.description,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.white),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => UpdateStudentDC(
                                            student: widget.student,
                                            disciplineCase: disciplineCase),
                                      ));
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.white),
                                    onPressed: () {
                                      _showDeleteDisciplineCaseDialog(
                                          disciplineCase);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildResults() {
    if (_results.isEmpty) {
      return _buildInfoRow('Results:', 'None');
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Results:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Subject')),
                DataColumn(label: Text('Grade'))
              ],
              rows: _results
                  .map((result) => DataRow(
                        cells: [
                          DataCell(Text(result.subject)),
                          DataCell(Text('     ' + result.grade)),
                        ],
                      ))
                  .toList(),
              columnSpacing: 200,
              dataRowHeight: 50,
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => Colors.grey),
              headingTextStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              dividerThickness: 2,
            ),
          ),
          //   for (var result in _results)
          //     Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text(
          //           'Subject: ${result.subject}',
          //           style: const TextStyle(fontSize: 16),
          //         ),
          //         Text(
          //           'Grade: ${result.grade}',
          //           style: const TextStyle(fontSize: 16),
          //         ),
          //         const SizedBox(height: 16),
          //       ],
          //     ),
          const SizedBox(height: 16),
        ],
      );
    }
  }
}
