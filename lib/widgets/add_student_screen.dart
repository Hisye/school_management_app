// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentDataEntry extends StatefulWidget {
  const StudentDataEntry({super.key});

  @override
  State<StudentDataEntry> createState() => _StudentDataEntryState();
}

class _StudentDataEntryState extends State<StudentDataEntry> {
  final _formKey = GlobalKey<FormState>();
  var _matricNo = '';
  var _stuFullName = '';
  var _course = '';

  Future<bool> _saveData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'shopping-list2-bcc4b-default-rtdb.asia-southeast1.firebasedatabase.app',
          'student-data.json');
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'Matric No': _matricNo,
              'Full Name': _stuFullName,
              'Course': _course,
            },
          ),
        );

        print(response.body);
        print(response.statusCode);

        if (!context.mounted) {
          return true;
        } else {
          // Handle successful response here
          return true;
        }
      } catch (error) {
        // Handle errors, and return false
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
        title: const Text('Add Student'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // Matric No
              TextFormField(
                maxLength: 10,
                decoration: const InputDecoration(
                  labelText: 'Matric No',
                  prefixIcon: Icon(
                    Icons.format_list_numbered,
                    size: 30,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Colors.purple,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 10) {
                    return 'Must be between 1 and 10 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _matricNo = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // Full Name
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(
                    Icons.person,
                    size: 30,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Colors.purple,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _stuFullName = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // Course
              TextFormField(
                maxLength: 30,
                decoration: const InputDecoration(
                  labelText: 'Course',
                  prefixIcon: Icon(
                    Icons.school,
                    size: 30,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Colors.purple,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 30) {
                    return 'Must be between 1 and 30 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _course = value!;
                },
              ),
              const SizedBox(
                height: 10,
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
                      if (_formKey.currentState!.validate()) {
                        bool success = await _saveData();
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data Entry Successful'),
                            ),
                          );
                          // Reset the form after successful data entry
                          _formKey.currentState!.reset();

                          print('#Debug main.dart -> Matric No: $_matricNo');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Error saving data. Please try again.'),
                            ),
                          );
                        }
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
