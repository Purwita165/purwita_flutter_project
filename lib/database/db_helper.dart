import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo.dart';

class DBHelper {
  // =========================
  // Singleton
  // =========================
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  // =========================
  // Database getter
  // =========================
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todo.db');
    return _database!;
  }

  // =========================
  // Init DB
  // =========================
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // =========================
  // Create Table
  // =========================
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        description TEXT NOT NULL,
        ref TEXT,
        priority INTEGER,
        isDone INTEGER
      )
    ''');
  }

  // =========================
  // INSERT
  // =========================
  Future<int> insertTodo(Todo todo) async {
    final db = await database;
    return await db.insert('todos', todo.toMap());
  }

  // =========================
  // SELECT ALL
  // =========================
  Future<List<Todo>> getTodos() async {
    final db = await database;
    final result = await db.query('todos', orderBy: 'id DESC');

    return result.map((json) => Todo.fromMap(json)).toList();
  }

  // =========================
  // UPDATE
  // =========================
  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // =========================
  // DELETE
  // =========================
  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  // =========================
  // CLOSE DB (opsional)
  // =========================
  Future<void> close() async {
    final db = await database;
    db.close();
  }

  Future<int> updateTodoStatus(int id, int isDone) async {
    final db = await database;
    return await db.update(
      'todos',
      {'isDone': isDone},
      where: 'id = ?',
      whereArgs: [id],
    );
  }  
}
