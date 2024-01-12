import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:school_management_app/models/firebase_user.dart';

import 'package:school_management_app/models/student.dart';

class AddStudentResult extends StatefulWidget {
  final Student student;
  const AddStudentResult({required this.student});

  @override
  _AddStudentResultState createState() => _AddStudentResultState();
}

class _AddStudentResultState extends State<AddStudentResult> {
  final _formKey = GlobalKey<FormState>();
  var _subjectGrade = 'A';
  var _subjectType = 'Mathematics';
  String adminPrefix = FirebaseHelper.getAdminPrefix();

  @override
  void initState() {
    super.initState();
  }

  final List<String> subjectGrade = ['A', 'B', 'C', 'D', 'E', 'F'];

  final List<String> disciplineTypes = [
    'Mathematics',
    'Bahasa Melayu',
    'English',
    'Sains',
    'Bahasa Arab'
  ];

  Future<bool> _saveData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/$adminPrefix/student-data/${widget.student.id}/result.json');
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'Subject': _subjectType,
              'Grade': _subjectGrade,
            },
          ),
        );

        print(response.body);
        print(response.statusCode);
        print('Grade: $_subjectGrade');
        print('Subject: $_subjectType');
        if (!context.mounted) {
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Subject result added successfully'),
            ),
          );
          Navigator.pop(context, true);
          return true;
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot add result'),
          ),
        );
        print('Error saving data: $error');
        return false;
      }
    } else {
      // Return false if validation fails
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exam Result'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Discipline Type Dropdown
              DropdownButtonFormField<String>(
                value: _subjectType,
                onChanged: (value) {
                  setState(() {
                    _subjectType = value!;
                  });
                },
                items: disciplineTypes.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Subject',
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  prefixIcon: const Icon(
                    Icons.category,
                    size: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelStyle: const TextStyle(
                    fontSize: 18,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Description
              DropdownButtonFormField<String>(
                value: _subjectGrade,
                onChanged: (value) {
                  setState(() {
                    _subjectGrade = value!;
                  });
                },
                items: subjectGrade.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Result',
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  prefixIcon: const Icon(
                    Icons.category,
                    size: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelStyle: const TextStyle(
                    fontSize: 18,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Date
              // TextFormField(
              //   decoration: InputDecoration(
              //     labelText: 'Date',
              //     labelStyle: const TextStyle(
              //         fontSize: 14, fontWeight: FontWeight.normal),
              //     prefixIcon: const Icon(Icons.calendar_today, size: 20),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: const BorderSide(color: Colors.grey, width: 2),
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     floatingLabelStyle: const TextStyle(
              //       fontSize: 18,
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //         borderSide: const BorderSide(width: 1.5),
              //         borderRadius: BorderRadius.circular(10)),
              //     suffixIcon: GestureDetector(
              //       onTap: () {
              //         _presentDatePicker();
              //       },
              //       child: const Icon(Icons.edit),
              //     ),
              //   ),
              //   readOnly: true,
              //   controller: _dateController,
              //   validator: (value) {
              //     // ... (rest of the code remains the same)
              //   },
              //   onSaved: (value) {
              //     // ... (rest of the code remains the same)
              //   },
              // ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _formKey.currentState!.reset();
                    },
                    child: const Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      bool success = await _saveData();
                      if (success) {
                        // Reset the form after successful data entry
                        _formKey.currentState!.reset();
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
