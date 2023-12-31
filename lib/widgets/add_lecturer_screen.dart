// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LecturerDataEntry extends StatefulWidget {
  const LecturerDataEntry({super.key});

  @override
  State<LecturerDataEntry> createState() => _LecturerDataEntryState();
}

class _LecturerDataEntryState extends State<LecturerDataEntry> {
  final _formKey = GlobalKey<FormState>();
  // Lecturer lecturer = Lecturer('', '', '', '');
  var _staffId = '';
  var _fullName = '';
  var _faculty = '';
  var _subject = '';

  Future<bool> _saveData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'shopping-list2-bcc4b-default-rtdb.asia-southeast1.firebasedatabase.app',
          'lecturer-data.json');
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
        title: const Text('Add Lecturer'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            // Staff ID
            TextFormField(
              maxLength: 10,
              decoration: const InputDecoration(
                labelText: 'Staff ID',
                prefixIcon: Icon(
                  Icons.badge,
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
                _staffId = value!;
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
                _fullName = value!;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            // Faculty
            TextFormField(
              maxLength: 10,
              decoration: const InputDecoration(
                labelText: 'Faculty',
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
              decoration: const InputDecoration(
                labelText: 'Subject',
                prefixIcon: Icon(
                  Icons.book,
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
    );
  }
}
