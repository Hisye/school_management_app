// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:school_management_app/models/firebase_user.dart';

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
  String adminPrefix = FirebaseHelper.getAdminPrefix();

  Future<bool> _saveData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/$adminPrefix/student-data.json');
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
              const SizedBox(
                height: 40,
              ),
              // Matric No
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Matric No',
                  hintText: 'Enter the student matric no',
                  labelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                  prefixIcon: const Icon(
                    Icons.format_list_numbered,
                    size: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  floatingLabelStyle: const TextStyle(
                    fontSize: 18,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5),
                      borderRadius: BorderRadius.circular(10)),
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
                height: 20,
              ),
              // Full Name
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter the student full name',
                  labelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                  prefixIcon: const Icon(
                    Icons.person,
                    size: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  floatingLabelStyle: const TextStyle(
                    fontSize: 18,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5),
                      borderRadius: BorderRadius.circular(10)),
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
                height: 20,
              ),
              // Course
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Course',
                  hintText: 'Enter the student course',
                  labelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                  prefixIcon: const Icon(
                    Icons.school,
                    size: 20,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.grey, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  floatingLabelStyle: const TextStyle(
                    fontSize: 18,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(width: 1.5),
                      borderRadius: BorderRadius.circular(10)),
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
                  _course = value!;
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
