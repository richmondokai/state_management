// providers/todo_provider.dart
import 'dart:convert'; // Add this import for json handling
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/todo.dart';
import '../services/shared_preferences_service.dart';
import '../services/api_service.dart';

class TodoState {
  final List<Todo> todos;
  final bool isLoading;
  final String? error;

  TodoState({this.todos = const [], this.isLoading = false, this.error});

  TodoState copyWith({List<Todo>? todos, bool? isLoading, String? error}) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class TodoNotifier extends StateNotifier<TodoState> {
  final SharedPreferencesService prefsService;
  final ApiService apiService;

  TodoNotifier(this.prefsService, this.apiService) : super(TodoState()) {
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    await prefsService.init();
    state = state.copyWith(isLoading: true);

    try {
      // First try to load from API
      final result = await apiService.get(
        'https://jsonplaceholder.typicode.com/todos',
      );

      if (result.error != null) {
        throw Exception(result.error);
      }

      final apiTodos =
          (result.data as List)
              .map(
                (item) => Todo(
                  id: item['id'].toString(),
                  title: item['title'],
                  completed: item['completed'],
                ),
              )
              .toList();

      state = state.copyWith(todos: apiTodos, isLoading: false);

      // Save to local storage
      await _saveTodos(apiTodos);
    } catch (e) {
      // Fallback to local storage if API fails
      final localTodos = await _getLocalTodos();
      state = state.copyWith(
        todos: localTodos,
        isLoading: false,
        error: 'Failed to load from API: $e',
      );
    }
  }

  Future<List<Todo>> _getLocalTodos() async {
    final todosJson = prefsService.getString('todos');
    if (todosJson == null) return [];

    try {
      final todosList = jsonDecode(todosJson) as List; // Changed to jsonDecode
      return todosList.map((item) => Todo.fromMap(item)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> _saveTodos(List<Todo> todos) async {
    final todosJson = jsonEncode(
      todos.map((todo) => todo.toMap()).toList(),
    ); // Changed to jsonEncode
    await prefsService.setString('todos', todosJson);
  }

  Future<void> addTodo(Todo todo) async {
    final newTodos = [...state.todos, todo];
    state = state.copyWith(todos: newTodos);
    await _saveTodos(newTodos);
  }

  Future<void> toggleTodo(String id) async {
    final newTodos =
        state.todos.map((todo) {
          if (todo.id == id) {
            return todo.copyWith(completed: !todo.completed);
          }
          return todo;
        }).toList();

    state = state.copyWith(todos: newTodos);
    await _saveTodos(newTodos);
  }

  Future<void> deleteTodo(String id) async {
    final newTodos = state.todos.where((todo) => todo.id != id).toList();
    state = state.copyWith(todos: newTodos);
    await _saveTodos(newTodos);
  }

  Future<void> refreshTodos() async {
    await _loadTodos();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  final prefsService = SharedPreferencesService();
  final apiService = ApiService();
  return TodoNotifier(prefsService, apiService);
});
