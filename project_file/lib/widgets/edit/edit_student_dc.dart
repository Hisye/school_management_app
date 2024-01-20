import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:school_management_app/models/student.dart';
import 'package:school_management_app/models/discipline_case.dart';
import 'package:school_management_app/models/firebase_user.dart';

class UpdateStudentDC extends StatefulWidget {
  final Student student;
  final DisciplineCase disciplineCase;

  const UpdateStudentDC({
    required this.student,
    required this.disciplineCase,
  });

  @override
  _UpdateStudentDCState createState() => _UpdateStudentDCState();
}

class _UpdateStudentDCState extends State<UpdateStudentDC> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _dateController;

  late String _description;
  late DateTime _date = DateTime.now();
  late String _disciplineType;
  String adminPrefix = FirebaseHelper.getAdminPrefix();

  @override
  void initState() {
    super.initState();
    _description = widget.disciplineCase.description;
    _disciplineType = widget.disciplineCase.disciplineType;
    _loadDateForDisciplineCase();
    _dateController =
        TextEditingController(text: DateFormat('dd-MM-yyyy').format(_date));
  }

  final List<String> disciplineTypes = [
    'Academic Misconduct',
    'Behavioral Violation',
    'Attendance Issue',
  ];

  void _presentDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _date) {
      setState(() {
        _date = pickedDate;
        _dateController.text = DateFormat('dd-MM-yyyy').format(_date);
      });
    }
  }

  Future<void> _loadDateForDisciplineCase() async {
    final url = Uri.https(
      'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/$adminPrefix/student-data/${widget.student.id}/discipline-case/${widget.disciplineCase.id}.json',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> disciplineData = json.decode(response.body);

      if (disciplineData != null) {
        // Only update _date if it hasn't been set yet
        if (_date == DateTime.now()) {
          DateTime _date = DateTime.parse(disciplineData['Date']);
          _dateController.text = DateFormat('dd-MM-yyyy').format(_date);
        }

        print('Date for discipline case ${widget.disciplineCase.id}: $_date');
      } else {
        // Handle case where disciplineData is null
      }
    } else {
      // Handle error when the HTTP request fails
      print(
          'Failed to load discipline case. Status code: ${response.statusCode}');
    }
  }

  Future<bool> _updateData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/$adminPrefix/student-data/${widget.student.id}/discipline-case/${widget.disciplineCase.id}.json');
      try {
        final response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'Discipline Type': _disciplineType,
              'Description': _description,
              'Date': _date.toIso8601String(),
            },
          ),
        );

        print(response.body);
        print(response.statusCode);
        print('Description: $_description');
        print('Date: $_date');
        print('Discipline Type: $_disciplineType');
        if (!context.mounted) {
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Discipline Case updated successfully'),
            ),
          );
          return true;
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot update Discipline Case'),
          ),
        );
        print('Error updating data: $error');
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
        title: const Text('Update Discipline Case'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: _loadDateForDisciplineCase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child:
                      CircularProgressIndicator()); // or any loading indicator
            } else if (snapshot.hasError) {
              return Text('Error loading date: ${snapshot.error}');
            } else {
              return Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Discipline Type Dropdown
                      DropdownButtonFormField<String>(
                        value: _disciplineType,
                        onChanged: (value) {
                          setState(() {
                            _disciplineType = value!;
                          });
                        },
                        items: disciplineTypes.map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Discipline Type',
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
                      TextFormField(
                        initialValue: _description,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter the discipline case description',
                          labelStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                          prefixIcon: const Icon(
                            Icons.description,
                            size: 20,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          floatingLabelStyle: const TextStyle(
                            fontSize: 18,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1.5),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _description = value!;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Date
                      TextFormField(
                        // initialValue: _initialDate,
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.normal),
                          prefixIcon:
                              const Icon(Icons.calendar_today, size: 20),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.grey, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          floatingLabelStyle: const TextStyle(
                            fontSize: 18,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(width: 1.5),
                              borderRadius: BorderRadius.circular(10)),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _presentDatePicker();
                            },
                            child: const Icon(Icons.edit),
                          ),
                        ),
                        readOnly: true,
                        controller: _dateController,
                        validator: (value) {
                          // ... (rest of the code remains the same)
                        },
                        onSaved: (value) {
                          // ... (rest of the code remains the same)
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              bool success = await _updateData();
                              if (success) {
                                // Return to the previous screen after successful update
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Update'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
