import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_listapp/screens/addtask.dart';
import 'package:to_do_listapp/screens/lists.dart';
import 'package:to_do_listapp/screens/task.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _removeTask(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve existing tasks
    List<String> taskList = prefs.getStringList('tasks') ?? [];

    // Remove the task at the specified index
    taskList.removeAt(index);

    // Save the updated list back to local storage
    await prefs.setStringList('tasks', taskList);

    // Update the UI to reflect the changes
    setState(() {
      tasks.removeAt(index);
    });
  }

  Future<void> clearAllTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('tasks');
  }

  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? taskStrings = prefs.getStringList('tasks');

    if (taskStrings == null) {
      print("No saved tasks to load.");
      return; // No saved tasks to load.
    }

    print("Loaded tasks: $taskStrings");

    List<Task> loadedTasks = taskStrings
        .map((taskString) => _decodeTask(taskString))
        .where((task) => task != null)
        .map((task) => task!)
        .toList();

    setState(() {
      tasks = loadedTasks;
    });
  }

  Task? _decodeTask(String json) {
    try {
      final Map<String, dynamic> taskMap = jsonDecode(json);
      return Task.fromJson(taskMap);
    } catch (e) {
      print("Error decoding JSON: $e");
      // Return a default or placeholder task here
      return Task(
          name: 'Error',
          description: 'Invalid data',
          date: DateTime.now(),
          category: 'Error');
    }
  }

  List<LinkModel> categories = [
    LinkModel(name: "Persnal", image: "assets/images/person.png"),
    LinkModel(name: "Health", image: "assets/images/person.png"),
    LinkModel(name: "Family", image: "assets/images/person.png"),
    LinkModel(name: "Education", image: "assets/images/person.png"),
  ];
  void addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
  }

  List<Task> tasks = [];
  // Future<void> clearTasks() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('tasks');
  // }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              "Hello Yaseen",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 32),
            ),
            Text(
              '${tasks.length} ${tasks.length == 1 ? 'Task' : 'Tasks'} are Pending.',
              style: TextStyle(color: Colors.blueGrey, fontSize: 15),
            ),
            const SizedBox(height: 20),
            Container(
              height: height * 0.04,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: const Row(
                children: [
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Icon(Icons.search),
                  Expanded(
                    child: TextField(
                        decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle:
                                TextStyle(color: Colors.blueGrey, fontSize: 18),
                            border: InputBorder.none)),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "Categories",
              style: TextStyle(color: Colors.blueGrey, fontSize: 28),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories
                    .map((e) => InkWell(
                          onTap: () {},
                          child: Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: SizedBox(
                                height: height * 0.21,
                                width: width * 0.35,
                                child: Column(
                                  children: [
                                    Image.asset(e.image),
                                    Text(
                                      e.name,
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                              )),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Today;s Tasks",
              style: TextStyle(color: Colors.blueGrey, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      height: height * 0.1,
                      width: width * 1,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(tasks[index].category),
                                Text(
                                  '${DateFormat('E, d MMMM y').format(tasks[index].date)} ${DateFormat('h:mm a').format(tasks[index].date)}',
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(tasks[index].name),
                                InkWell(
                                    onTap: () {
                                      _removeTask(index);
                                    },
                                    child: Icon(Icons.delete)),
                              ],
                            ),
                            Divider(
                              color: Colors.black,
                            ),
                            Text(tasks[index].description)
                          ],
                        ),
                      ),
                    ),
                  );
                })),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskPage(categories: categories),
                  ),
                );
              },
              child: Text('Add Task'),
            ),
            ElevatedButton(
              onPressed: () {
                // Call the function to clear all tasks
                clearAllTasks();
              },
              child: Text('Clear All Tasks'),
            ),
          ]),
        ),
      ),
    );
  }
}
