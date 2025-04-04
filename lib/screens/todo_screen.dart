// screens/todo_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../providers/todo_provider.dart';
import '../controllers/form_controller.dart';

class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends ConsumerState<TodoScreen> {
  late FormController _formController;
  final _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formController = FormController(
      values: {'title': ''},
      validate: (values) {
        final errors = <String, String>{};
        if (values['title'].isEmpty) errors['title'] = 'Title is required';
        return errors;
      },
    );
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoState = ref.watch(todoProvider);
    final todoNotifier = ref.read(todoProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Todo App')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _todoController,
                    decoration: const InputDecoration(
                      labelText: 'New Todo',
                      border: OutlineInputBorder(),
                    ),
                    onChanged:
                        (value) => _formController.setValue('title', value),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed:
                      _formController.isSubmitting
                          ? null
                          : () {
                            if (_formController.errors.isEmpty) {
                              final newTodo = Todo(
                                id:
                                    DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                title: _formController.values['title'],
                              );
                              todoNotifier.addTodo(newTodo);
                              _todoController.clear();
                              _formController.setValue('title', '');
                            }
                          },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          if (_formController.touched['title'] == true &&
              _formController.errors['title'] != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                _formController.errors['title']!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child:
                todoState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : todoState.error != null
                    ? Center(child: Text('Error: ${todoState.error}'))
                    : ListView.builder(
                      itemCount: todoState.todos.length,
                      itemBuilder: (context, index) {
                        final todo = todoState.todos[index];
                        return Dismissible(
                          key: Key(todo.id),
                          background: Container(color: Colors.red),
                          onDismissed: (_) => todoNotifier.deleteTodo(todo.id),
                          child: CheckboxListTile(
                            title: Text(todo.title),
                            value: todo.completed,
                            onChanged: (_) => todoNotifier.toggleTodo(todo.id),
                            secondary: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => todoNotifier.deleteTodo(todo.id),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => todoNotifier.refreshTodos(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
