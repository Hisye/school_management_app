import 'package:flutter/material.dart';
import 'package:school_management_app/models/student.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_management_app/widgets/add/add_student_screen.dart';
import 'package:school_management_app/widgets/info/student_info_screen.dart';
import 'package:school_management_app/models/firebase_user.dart';


class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> _studentList = [];
  List<Student> _filteredStudentList = [];
  TextEditingController _searchController = TextEditingController();
    String adminPrefix = FirebaseHelper.getAdminPrefix();


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final url = Uri.https(
      'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/$adminPrefix/student-data.json',
    );
    final response = await http.get(url);
    print('#debug student-list.dart');
    print(response.body);
    final Map<String, dynamic> listData = json.decode(response.body);
    print('#debug student-list.dart');
    print(listData);
    final List<Student> _loadedData = [];
    for (final data in listData.entries) {
      _loadedData.add(
        Student(
          id: data.key,
          matricNo: data.value['Matric No'],
          fullName: data.value['Full Name'],
          course: data.value['Course'],
        ),
      );
    }

    setState(() {
      _studentList = _loadedData;
    });
  }

  void _addData() async {
    await Navigator.of(context).push<Student>(
      MaterialPageRoute(
        builder: (ctx) => const StudentDataEntry(),
      ),
    );

    _loadData();
  }

  void _removeData(Student data) async {
    bool shouldDelete = await _showDeleteConfirmation(context);

    if (shouldDelete) {
      final url = Uri.https(
        'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/$adminPrefix/student-data/${data.id}.json',
      );

      try {
        final response = await http.delete(url);

        if (response.statusCode == 200) {
          // If the delete request is successful, remove the data from the local list
          setState(() {
            _studentList.remove(data);
          });

          // show snackbar to indicate delete success
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Student data deleted successfully.'),
            ),
          );
        } else {
          // Handle error - print or display an error message
          print('Failed to delete data: ${response.statusCode}');
        }
      } catch (error) {
        // Handle other errors
        print('Error: $error');
      }
    }
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this student?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _searchStudent(String query) {
    setState(() {
      _filteredStudentList = _studentList
          .where((student) =>
              student.matricNo.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        'No student data yet...!',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (_studentList.isNotEmpty) {
      content = ListView.builder(
        itemCount: _studentList.length,
        itemBuilder: (context, index) => Dismissible(
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          confirmDismiss: (direction) async {
            return await _showDeleteConfirmation(context);
          },
          onDismissed: (direction) async {
            bool shouldDelete = await _showDeleteConfirmation(context);
            if (shouldDelete) {
              _removeData(_studentList[index]);
            }
          },
          key: ValueKey(_studentList[index].id),
          child: ListTile(
            title: Text(_studentList[index].fullName),
            subtitle: Text(_studentList[index].course),
            trailing: Text(
              _studentList[index].matricNo,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => StudentInfo(student: _studentList[index]),
              ));
            },
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: StudentSearchDelegate(
                      _searchController, _searchStudent, _studentList));
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: _addData,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: content,
    );
  }
}

class StudentSearchDelegate extends SearchDelegate {
  final TextEditingController _searchController;
  final Function(String) _onSearch;
  final List<Student> _studentList;

  StudentSearchDelegate(
      this._searchController, this._onSearch, this._studentList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          _searchController.clear();
          _onSearch('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _onSearch(_searchController.text);
    return ListView.builder(
        itemCount: _studentList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_studentList[index].fullName),
            subtitle: Text(_studentList[index].course),
            trailing: Text(
              _studentList[index].matricNo,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => StudentInfo(student: _studentList[index]),
              ));
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = _studentList
        .where((student) =>
            student.matricNo.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestionList[index].fullName),
            subtitle: Text(suggestionList[index].course),
            trailing: Text(
              suggestionList[index].matricNo,
            ),
            onTap: () {
              // _searchController.text = suggestionList[index].matricNo;
              // WidgetsBinding.instance!.addPostFrameCallback((_) {
              //   showResults(context);
              // });
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    StudentInfo(student: suggestionList[index]),
              ));
            },
          );
        });
  }
}
