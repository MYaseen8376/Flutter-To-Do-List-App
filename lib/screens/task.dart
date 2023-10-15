class Task {
  String name;
  String description;
  DateTime date;
  String category;

  Task({
    required this.name,
    required this.description,
    required this.date,
    required this.category,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      name: json['name'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      category: json['category'],
    );
  }
}
