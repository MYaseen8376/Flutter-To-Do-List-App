import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_listapp/screens/lists.dart';

class AddTaskPage extends StatefulWidget {
  final List<LinkModel> categories;
  AddTaskPage({required this.categories});
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final DateFormat _dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();
  DateTime selectedDate = DateTime.now();
  final TextEditingController taskDateTimeController = TextEditingController();
  String selectedCategory = 'Work';
  List<String> categories = [
    'Work',
    'Education',
    'Persnal',
    'Health',
    'Family'
  ];

  Future<void> _saveTask() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> task = {
      'name': taskNameController.text,
      'description': taskDescriptionController.text,
      'date': selectedDate.toIso8601String(),
      'category': selectedCategory,
    };
    String taskString = jsonEncode(task);
    List<String> taskList = prefs.getStringList('tasks') ?? [];
    taskList.add(taskString);
    await prefs.setStringList('tasks', taskList);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Create New Task',
        ),
        backgroundColor: Colors.green[400],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            width: double.infinity,
            height: height * 0.3,
            decoration: BoxDecoration(
                color: Colors.green[400],
                borderRadius:
                    const BorderRadius.only(bottomLeft: Radius.circular(50))),
            child: Image.asset(
              "assets/images/bgicon.png",
              scale: 2.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: taskNameController,
                  decoration: InputDecoration(
                    hintText: 'Task Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.green)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: taskDescriptionController,
                  decoration: InputDecoration(
                    hintText: 'Task Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded border
                      borderSide:
                          BorderSide(color: Colors.grey), // Border color
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text("Select Date & Time"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded button shape
                    ),
                  ),
                ),
                TextField(
                  controller: taskDateTimeController,
                  decoration: InputDecoration(
                    labelText: 'Task Date and Time',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    onChanged: (String? value) {
                      setState(() {
                        selectedCategory = value ?? 'Work';
                      });
                    },
                    items: categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text(category),
                        ),
                      );
                    }).toList(),
                    underline: Container(),
                    icon: const Icon(Icons.arrow_drop_down),
                    style: const TextStyle(color: Colors.black),
                    isExpanded: true,
                    itemHeight: 50,
                  ),
                ),
                ElevatedButton(
                  onPressed: _saveTask,
                  child: const Text("Save Task"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Button background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDate),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          taskDateTimeController.text = _dateFormat.format(selectedDate);
        });
      }
    }
  }
}
