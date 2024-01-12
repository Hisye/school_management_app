import 'package:flutter/material.dart';
import 'package:school_management_app/models/teacher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:school_management_app/models/firebase_user.dart';

class EditTeacherData extends StatefulWidget {
  final Teacher teacher;

  const EditTeacherData({
    super.key,
    required this.teacher,
  });

  @override
  State<EditTeacherData> createState() => _EditTeacherDataState();
}

class _EditTeacherDataState extends State<EditTeacherData> {
  final _formKey = GlobalKey<FormState>();
  late String _fullNameController;
  late String _staffIdController;
  late String _facultyController;
  late String _subjectController;
  List<Teacher> _teacherList = [];
  String adminPrefix = FirebaseHelper.getAdminPrefix();

  void initState() {
    super.initState();
    _fullNameController = widget.teacher.fullName;
    _staffIdController = widget.teacher.staffId;
    _facultyController = widget.teacher.faculty;
    _subjectController = widget.teacher.subject;
  }

  Future<bool> _updateTeacherData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/$adminPrefix/teacher-data/${widget.teacher.id}.json');
      try {
        final response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'Staff ID': _staffIdController,
              'Full Name': _fullNameController,
              'Faculty': _facultyController,
              'Subject': _subjectController,
            },
          ),
        );

        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (!context.mounted) {
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Teacher data updated successfully'),
            ),
          );
          await _loadData();
          // ignore: use_build_context_synchronously
          Navigator.pop(context, true);
          return true;
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot update teacher data'),
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

  Future<void> _loadData() async {
    final url = Uri.https(
      'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/$adminPrefix/teacher-data.json',
    );

    try {
      final response = await http.get(url);
      print('#debug Lecturer-list.dart');
      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> listData = json.decode(response.body);
        print('#debug Lecturer-list.dart');
        print(listData);

        final List<Teacher> _loadedData = [];
        for (final data in listData.entries) {
          _loadedData.add(
            Teacher(
              id: data.key,
              staffId: data.value['Staff ID'],
              fullName: data.value['Full Name'],
              faculty: data.value['Faculty'],
              subject: data.value['Subject'],
            ),
          );
        }

        setState(() {
          _teacherList = _loadedData;
          print('teacher list: ${_teacherList.length}');
        });
      } else {
        // Handle error - print or display an error message
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Teacher'),
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
              // Staff id
              TextFormField(
                initialValue: _staffIdController,
                decoration: InputDecoration(
                  labelText: 'Staff Id',
                  hintText: 'Enter the teacher staff id',
                  labelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                  prefixIcon: const Icon(
                    Icons.badge,
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
                  _staffIdController = value!;
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
                  hintText: 'Enter the teacher full name',
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
                initialValue: _facultyController,
                decoration: InputDecoration(
                  labelText: 'Faculty',
                  hintText: 'Enter the teacher faculty',
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
                  _facultyController = value!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                initialValue: _subjectController,
                decoration: InputDecoration(
                  labelText: 'Subject',
                  hintText: 'Enter the teacher subject',
                  labelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                  prefixIcon: const Icon(
                    Icons.book,
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
                  _subjectController = value!;
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
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _updateTeacherData();
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
