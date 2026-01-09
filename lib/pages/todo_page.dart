import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  // =========================
  // State
  // =========================
  List<Todo> todos = [];

  final TextEditingController descController = TextEditingController();
  final TextEditingController refController = TextEditingController();

  int priority = 1; // 1=Low, 2=Moderate, 3=High

  // =========================
  // Lifecycle
  // =========================
  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  @override
  void dispose() {
    descController.dispose();
    refController.dispose();
    super.dispose();
  }

  // =========================
  // Load Todos
  // =========================
  Future<void> loadTodos() async {
    final data = await DBHelper.instance.getTodos();
    setState(() {
      todos = data;
    });
  }

  // =========================
  // Add Todo
  // =========================
  Future<void> addTodo() async {
    if (descController.text.trim().isEmpty) return;

    final todo = Todo(
      description: descController.text,
      ref: refController.text.isEmpty ? null : refController.text,
      priority: priority,
      isDone: 0,
    );

    await DBHelper.instance.insertTodo(todo);
    await loadTodos();

    descController.clear();
    refController.clear();
  }

  Future<void> toggleTodo(Todo todo) async {
    final newStatus = todo.isDone == 1 ? 0 : 1;

    await DBHelper.instance.updateTodoStatus(todo.id!, newStatus);

    await loadTodos();
  }

  String priorityLabel(int value) {
    switch (value) {
      case 1:
        return 'Low';
      case 2:
        return 'Moderate';
      case 3:
        return 'High';
      default:
        return 'Low';
    }
  }

  Future<void> removeTodo(Todo todo) async {
    await DBHelper.instance.deleteTodo(todo.id!);
    await loadTodos();
  }

  Future<void> confirmDelete(Todo todo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await removeTodo(todo);
    }
  }

  // =========================
  // UI
  // =========================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo List')),
      body: Column(
        children: [
          // ===== Input Section =====
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Task Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: refController,
                  decoration: const InputDecoration(
                    labelText: 'Ref (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('Priority'),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _priorityOption(label: 'Low', value: 1),
                          _priorityOption(label: 'Moderate', value: 2),
                          _priorityOption(label: 'High', value: 3),
                        ],
                      ),
                    ),

                    ElevatedButton(
                      onPressed: addTodo,
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(),

          // ===== List Section =====
          Expanded(
            child: todos.isEmpty
                ? const Center(child: Text('No tasks yet'))
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                        leading: Checkbox(
                          value: todo.isDone == 1,
                          onChanged: (_) => toggleTodo(todo),
                        ),
                        title: Text(
                          todo.description,
                          style: TextStyle(
                            decoration: todo.isDone == 1
                                ? TextDecoration.lineThrough
                                : null,
                            color: todo.isDone == 1
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                        subtitle: todo.ref != null
                            ? Text(
                                'Ref: ${todo.ref}',
                                style: const TextStyle(color: Colors.grey),
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              priorityLabel(todo.priority),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => confirmDelete(todo),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _priorityOption({required String label, required int value}) {
    return InkWell(
      onTap: () {
        setState(() {
          priority = value;
        });
      },
      child: Row(
        children: [
          Radio<int>(
            value: value,
            groupValue: priority,
            onChanged: (val) {
              setState(() {
                priority = val!;
              });
            },
          ),
          Text(label),
        ],
      ),
    );
  }
}
