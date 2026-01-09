class Todo {
  int? id;
  String description;
  String? ref;
  int priority; // 1=Low, 2=Moderate, 3=High
  int isDone;   // 0=false, 1=true

  Todo({
    this.id,
    required this.description,
    this.ref,
    required this.priority,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'ref': ref,
      'priority': priority,
      'isDone': isDone,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      description: map['description'],
      ref: map['ref'],
      priority: map['priority'],
      isDone: map['isDone'],
    );
  }
}
