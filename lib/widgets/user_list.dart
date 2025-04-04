// widgets/user_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

class UserList extends ConsumerStatefulWidget {
  const UserList({super.key});

  @override
  ConsumerState<UserList> createState() => _UserListState();
}

class _UserListState extends ConsumerState<UserList> {
  final ApiService _apiService = ApiService();
  bool isLoading = true;
  String? error;
  List<dynamic>? users;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => isLoading = true);
    final result = await _apiService.get(
      'https://jsonplaceholder.typicode.com/users',
    );
    setState(() {
      isLoading = false;
      error = result.error;
      users = result.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (error != null) return Center(child: Text('Error: $error'));
    if (users == null || users!.isEmpty)
      return const Center(child: Text('No users found'));

    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Users from API',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                TextButton(
                  onPressed: _fetchUsers,
                  child: const Text('Refresh'),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: users!.length,
              itemBuilder:
                  (context, index) => ListTile(
                    leading: CircleAvatar(
                      child: Text(users![index]['id'].toString()),
                    ),
                    title: Text(users![index]['name']),
                    subtitle: Text(users![index]['email']),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
