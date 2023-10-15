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
  String selectedCategory = 'Work'; // Default category
  List<String> categories = ['Work', 'Education', 'Tasks'];

  Future<void> _saveTask() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Create a task object
    Map<String, dynamic> task = {
      'name': taskNameController.text,
      'description': taskDescriptionController.text,
      'date': selectedDate.toIso8601String(),
      'category': selectedCategory,
    };

    // Use jsonEncode to convert the task to a JSON string
    String taskString = jsonEncode(task);

    // Retrieve existing tasks or create a new list
    List<String> taskList = prefs.getStringList('tasks') ?? [];

    // Add the task to the list
    taskList.add(taskString);

    // Save the updated list back to local storage
    await prefs.setStringList('tasks', taskList);

    // Navigate back to the previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: taskNameController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              controller: taskDescriptionController,
              decoration: InputDecoration(labelText: 'Task Description'),
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text("Select Date"),
            ),
            TextField(
              controller: taskDateTimeController,
              decoration: InputDecoration(labelText: 'Task Date and Time'),
            ),
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (String? value) {
                setState(() {
                  selectedCategory = value ?? 'Work';
                });
              },
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text("Save Task"),
            ),
          ],
        ),
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
