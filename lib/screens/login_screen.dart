// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../controllers/form_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key}); // Added named 'key' parameter

  @override
  ConsumerState<LoginScreen> createState() => LoginScreenState(); // Changed to public type
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  // Made public
  late FormController _formController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formController = FormController(
      values: {'email': '', 'password': ''},
      validate: (values) {
        final errors = <String, String>{};
        if (values['email'].isEmpty) errors['email'] = 'Email is required';
        if (values['password'].isEmpty)
          errors['password'] = 'Password is required';
        return errors;
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => _formController.setValue('email', value),
              ),
              if (_formController.touched['email'] == true &&
                  _formController.errors['email'] != null)
                Text(
                  _formController.errors['email']!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged:
                    (value) => _formController.setValue('password', value),
              ),
              if (_formController.touched['password'] == true &&
                  _formController.errors['password'] != null)
                Text(
                  _formController.errors['password']!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed:
                    _formController.isSubmitting
                        ? null
                        : () => _formController.submit((values) async {
                          await ref
                              .read(authProvider.notifier)
                              .login(
                                User(name: 'User', email: values['email']),
                              );
                        }),
                child: Text(
                  _formController.isSubmitting ? 'Logging in...' : 'Log In',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
