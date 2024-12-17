import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:todo_101/components/todo_tile.dart';
import 'package:todo_101/todo_storage.dart';
import 'todo.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final TodoStorage _storage = TodoStorage();
  final TextEditingController _controller = TextEditingController();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  //function to dismiss the keyboard when tapped outside
  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  // Load saved todos when the app starts
  Future<void> _loadTodos() async {
    final todos = await _storage.loadTodos();
    setState(() {
      _todos = todos;
    });
  }

  // Add a new todo
  void _addTodo() {
    final title = _controller.text.trim();
    if (title.isNotEmpty) {
      setState(() {
        _todos.add(Todo(title: title));
      });
      _storage.saveTodos(_todos); // Persist the updated list
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Task added to list'),
          backgroundColor: Colors.blueGrey[700],
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a task'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Delete a todo
  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
    _storage.saveTodos(_todos); // Update SharedPreferences
  }

  // Clear all todos
  void _clearTodos() async {
    await _storage.clearTodos();
    setState(() {
      _todos.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: const Text(
          'To-Do App',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              IconlyBold.delete,
              color: Colors.white,
            ),
            onPressed: () {
              _clearTodos();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('All tasks cleared!'),
                  backgroundColor: Colors.blueGrey[700],
                ),
              );
            }, // Clear all todos
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: GestureDetector(
        onTap: _dismissKeyboard,
        child: Column(
          children: [
            // Input field to add new todos
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.blueGrey[900],
                      controller: _controller,
                      onSubmitted: (context) {
                        _addTodo();
                        _dismissKeyboard();
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blueGrey[900]!)),
                        labelText: 'Add a task',
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  //floating action button
                  FloatingActionButton(
                    backgroundColor: Colors.blueGrey[900],
                    onPressed: () {
                      _addTodo();
                      _dismissKeyboard();
                    },
                    tooltip: 'Add to the list',
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // List of todos
            TodoTile(
                todos: _todos,
                onPressed: (index) {
                  _deleteTodo(index);
                })
          ],
        ),
      ),
    );
  }
}
