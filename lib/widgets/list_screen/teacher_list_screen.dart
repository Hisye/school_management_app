import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_management_app/models/teacher.dart';
import 'package:school_management_app/widgets/add/add_teacher_screen.dart';
import 'package:school_management_app/widgets/info/teacher_info_screen.dart';
import 'package:school_management_app/models/firebase_user.dart';

class TeacherListScreen extends StatefulWidget {
  const TeacherListScreen({super.key});

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState();
}

class _TeacherListScreenState extends State<TeacherListScreen> {
  List<Teacher> _teacherList = [];
  List<Teacher> _filteredTeacherList = [];
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
      '/$adminPrefix/teacher-data.json',
    );
    final response = await http.get(url);
    print('#debug Lecturer-list.dart');
    print(response.body);
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
  }

  void _addData() async {
    await Navigator.of(context).push<Teacher>(
      MaterialPageRoute(
        builder: (ctx) => const TeacherDataEntry(),
      ),
    );

    _loadData();
  }

  void _removeData(Teacher data) async {
    final url = Uri.https(
      'school-management-app-f5bfc-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/$adminPrefix/teacher-data/${data.id}.json',
    );
    try {
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // If the delete request is successful, remove the data from the local list
        setState(() {
          _teacherList.remove(data);
        });

        // show snackbar to indicate delete success
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Teacher data deleted successfully.'),
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

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this lecturer?'),
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

  void _searchTeacher(String query) {
    setState(() {
      _filteredTeacherList = _teacherList
          .where((teacher) =>
              teacher.staffId.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text(
        'No teacher data yet...!',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if (_teacherList.isNotEmpty) {
      content = ListView.builder(
        itemCount: _teacherList.length,
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
          onDismissed: (direction) {
            _removeData(_teacherList[index]);
          },
          key: ValueKey(_teacherList[index].id),
          child: ListTile(
            title: Text(_teacherList[index].fullName),
            subtitle: Text(_teacherList[index].staffId),
            trailing: Text(
              _teacherList[index].faculty,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TeacherInfo(teacher: _teacherList[index]),
              ));
            },
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher List'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: TeacherSearchDelegate(
                      _searchController, _searchTeacher, _teacherList));
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

class TeacherSearchDelegate extends SearchDelegate {
  final TextEditingController _searchController;
  final Function(String) _onSearch;
  final List<Teacher> _teacherList;

  TeacherSearchDelegate(
      this._searchController, this._onSearch, this._teacherList);

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
    _onSearch(query);
    return ListView.builder(
        itemCount: _teacherList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_teacherList[index].fullName),
            subtitle: Text(_teacherList[index].staffId),
            trailing: Text(
              _teacherList[index].faculty,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TeacherInfo(teacher: _teacherList[index]),
              ));
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = _teacherList
        .where((teacher) =>
            teacher.staffId.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(suggestionList[index].fullName),
            subtitle: Text(suggestionList[index].staffId),
            trailing: Text(
              suggestionList[index].faculty,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    TeacherInfo(teacher: suggestionList[index]),
              ));
            },
          );
        });
  }
}
