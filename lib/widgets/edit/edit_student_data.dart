import 'package:flutter/material.dart';
import 'package:school_management_app/models/student.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:school_management_app/models/firebase_user.dart';

class EditStudentData extends StatefulWidget {
  final Student student;

  const EditStudentData({
    super.key,
    required this.student,
  });

  @override
  State<EditStudentData> createState() => _EditStudentDataState();
}

class _EditStudentDataState extends State<EditStudentData> {
  final _formKey = GlobalKey<FormState>();
  late String _fullNameController;
  late String _matricNoController;
  late String _courseController;
  String adminPrefix = FirebaseHelper.getAdminPrefix();

  void initState() {
    super.initState();
    _fullNameController = widget.student.fullName;
    _matricNoController = widget.student.matricNo;
    _courseController = widget.student.course;
  }

  Future<bool> _updateStudentData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
        'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
        '$adminPrefix/student-data/${widget.student.id}.json',
      );

      try {
        // Fetch existing student data
        final response = await http.get(url);
        final existingData = json.decode(response.body);

        // Update only the fields you want to modify
        existingData['Matric No'] = _matricNoController;
        existingData['Full Name'] = _fullNameController;
        existingData['Course'] = _courseController;

        // Now, update the student data with the modified data
        final updateResponse = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(existingData),
        );

        // Handle the response as needed
        print(updateResponse.body);
        print(updateResponse.statusCode);
        print('Full Name: $_fullNameController');
        print('Matric no: $_matricNoController');
        print('Course: $_courseController');

        if (!context.mounted) {
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Student data updated successfully'),
            ),
          );
          Navigator.pop(context, true);
          return true;
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot update student data'),
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
        title: const Text('Edit Student'),
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
                initialValue: _matricNoController,
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
                  _matricNoController = value!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              // Full Name
              TextFormField(
                initialValue: _fullNameController,
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
                  _fullNameController = value!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              // Course
              TextFormField(
                initialValue: _courseController,
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
                      value.trim().length > 30) {
                    return 'Must be between 1 and 30 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _courseController = value!;
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
                        await _updateStudentData();
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
