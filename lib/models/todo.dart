// 01
class Todo {
  final int? id;
  final String title;
  final String description;
  final bool isDone;

  // 02
  Todo({
    this.id,
    required this.title,
    required this.description,
    this.isDone = false,
  });

  // 03
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0,
    };
  }

  // 04
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'] == 1,
    );
  }
}
