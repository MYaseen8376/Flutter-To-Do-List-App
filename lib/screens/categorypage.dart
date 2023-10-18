import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_listapp/screens/task.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  final List<Task> tasks;
  const CategoryPage({super.key, required this.category, required this.tasks});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Task> filteredTasks = [];

  @override
  void initState() {
    super.initState();
    filteredTasks = filterTasksByCategory(widget.category, widget.tasks);
  }

  List<Task> filterTasksByCategory(String category, List<Task> tasks) {
    if (category == 'All') {
      return tasks;
    } else {
      return tasks.where((task) => task.category == category).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text(widget.category),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: filteredTasks.isEmpty ? 1 : filteredTasks.length,
              itemBuilder: (context, index) {
                if (filteredTasks.isEmpty) {
                  return const Center(
                      child: Text(
                    "No tasks available in this category",
                    style: TextStyle(color: Colors.black),
                  ));
                }
                final task = filteredTasks[index];
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              task.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              '${DateFormat('E, d MMMM y').format(task.date)} ${DateFormat('h:mm a').format(task.date)}',
                            ),
                          ],
                        ),
                        const Divider(color: Colors.black),
                        Text(
                          task.description,
                          style: const TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
