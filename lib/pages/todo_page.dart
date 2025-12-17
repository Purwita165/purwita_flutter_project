import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Todo> todos = [];
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final data = await DBHelper.instance.getTodos();
    setState(() {
      todos = data;
    });
  }

  Future<void> addTodo() async {
    final title = titleController.text.trim();
    final desc = descController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title tidak boleh kosong')),
      );
      return;
    }

    await DBHelper.instance.insertTodo(
      Todo(
        title: title,
        description: desc,
      ),
    );

    titleController.clear();
    descController.clear();

    await loadTodos();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Todo berhasil ditambahkan')),
    );
  }

  Future<void> toggleTodo(Todo todo) async {
    await DBHelper.instance.updateTodo(
      Todo(
        id: todo.id,
        title: todo.title,
        description: todo.description,
        isDone: !todo.isDone,
      ),
    );
    await loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await DBHelper.instance.deleteTodo(id);
    await loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SQLite Todo List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await addTodo();
                    },
                    child: const Text('Add Todo'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: todos.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada todo',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration: todo.isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Text(todo.description),
                        leading: Checkbox(
                          value: todo.isDone,
                          onChanged: (_) => toggleTodo(todo),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          tooltip: 'Delete Todo',
                          onPressed: () => deleteTodo(todo.id!),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
