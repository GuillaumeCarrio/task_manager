class Task {
  String id;
  String name;
  String description;
  bool done;

  Task({required this.id, required this.name, required this.description, required this.done});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      done: json['done'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'done': done,
    };
  }
}