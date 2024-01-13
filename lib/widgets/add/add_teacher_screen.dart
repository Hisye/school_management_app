// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:school_management_app/models/firebase_user.dart';

class TeacherDataEntry extends StatefulWidget {
  const TeacherDataEntry({super.key});

  @override
  State<TeacherDataEntry> createState() => _TeacherDataEntryState();
}

class _TeacherDataEntryState extends State<TeacherDataEntry> {
  final _formKey = GlobalKey<FormState>();
  String adminPrefix = FirebaseHelper.getAdminPrefix();
  var _staffId = '';
  var _fullName = '';
  var _faculty = '';
  var _subject = '';

  Future<bool> _saveData() async {
    // if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    final url = Uri.https(
        'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/$adminPrefix/teacher-data.json');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'Staff ID': _staffId,
            'Full Name': _fullName,
            'Faculty': _faculty,
            'Subject': _subject,
          },
        ),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

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
    // } else {
    //   // Return false if validation fails
    //   return false;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Teacher'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30,),
              // Staff ID
              TextFormField(
                maxLength: 10,
                decoration:  InputDecoration(
                  labelText: 'Staff ID',
                  hintText: 'Enter the teacher staff id',
                  labelStyle:
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  prefixIcon: const Icon(
                    Icons.badge,
                    size: 30,
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
                  _staffId = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // Full Name
              TextFormField(
                maxLength: 50,
                decoration:  InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter the teacher full name',
                  labelStyle:
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  prefixIcon: const Icon(
                    Icons.person,
                    size: 30,
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
                  _fullName = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // Faculty
              TextFormField(
                maxLength: 10,
                decoration:  InputDecoration(
                  labelText: 'Faculty',
                  hintText: 'Enter the teacher faculty',
                  labelStyle:
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  prefixIcon: const Icon(
                    Icons.school,
                    size: 30,
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
                  _faculty = value!;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              // Subject
              TextFormField(
                maxLength: 30,
                decoration:  InputDecoration(
                  labelText: 'Subjevt',
                  hintText: 'Enter the teacher subject',
                  labelStyle:
                      const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                  prefixIcon: const Icon(
                    Icons.book,
                    size: 30,
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
                      value.trim().length > 30) {
                    return 'Must be between 1 and 30 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _subject = value!;
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
                        print(success);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data Entry Successful'),
                            ),
                          );
                          // Reset the form after successful data entry
                          _formKey.currentState!.reset();

                          print('#Debug main.dart -> Staff ID : $_staffId');
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
