import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddStudentDC extends StatefulWidget {
  const AddStudentDC({Key? key}) : super(key: key);

  @override
  _AddStudentDCState createState() => _AddStudentDCState();
}

// ... (rest of the imports)

class _AddStudentDCState extends State<AddStudentDC> {
  final _formKey = GlobalKey<FormState>();
  var _description = '';
  late DateTime _date = DateTime.now();
  var _disciplineType = 'Academic Misconduct';
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
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

  Future<bool> _saveData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // For demonstration purposes, let's print the values.
      print('Description: $_description');
      print('Date: $_date');
      print('Discipline Type: $_disciplineType');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Discipline Case added successfully'),
        ),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot add Discipline Case'),
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Discipline Case'),
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
                decoration: InputDecoration(
                  labelText: 'Date',
                  labelStyle: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                  prefixIcon: const Icon(Icons.calendar_today, size: 20),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 2),
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
