class Todo {
  String title;

  Todo({required this.title});

  // Convert a Todo object to a Map (for saving to SharedPreferences)
  Map<String, dynamic> toMap() {
    return {'title': title};
  }

  // Create a Todo object from a Map (when loading from SharedPreferences)
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(title: map['title'] as String);
  }
}
