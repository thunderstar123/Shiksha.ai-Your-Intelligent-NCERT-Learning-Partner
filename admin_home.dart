// lib/admin_home.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart'; // Import the login page

class AdminHome extends StatefulWidget {
  final String name;

  const AdminHome({super.key, required this.name});
  
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _role = 'user';
  bool _isLoading = false;
  String? _message;

  Future<void> _addUser() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    // For simplicity, using hardcoded admin credentials
    // In production, use a secure method to handle admin authentication
    final response = await http.post(
      Uri.parse('http://10.145.122.81:5000/add_user'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'admin_username': 'admin', // Replace with actual admin username
        'admin_password': 'adminpass', // Replace with actual admin password
        'name': _nameController.text,
        'email': _emailController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'role': _role,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['status'] == 'success') {
      setState(() {
        _message = 'User added successfully';
      });
      _nameController.clear();
      _emailController.clear();
      _usernameController.clear();
      _passwordController.clear();
      setState(() {
        _role = 'user';
      });
    } else {
      setState(() {
        _message = data['message'] ?? 'Failed to add user';
      });
    }
  }

  void _logout() async {
    // Navigate back to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
  );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
  title: const Text('Admin Home'),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 16.0, top: 8.0), // Adjust these values to move the button
      child: SizedBox(
        width: 130.0,  // Increase button width
        height: 30.0,  // Increase button height
        child: ElevatedButton(
          onPressed: _logout,
          style: ElevatedButton.styleFrom(
            //backgroundColor: const Color.fromRGBO(234, 238, 241, 1), // Corrected from 'primary' to 'backgroundColor'
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Optional: rounded corners
            ),
          ),
          child: const Text(
            'Logout',
            style: TextStyle(
              color: Color.fromARGB(255, 37, 136, 216),
              fontSize: 24.0,  // Increase font sizes
            ),
          ),
        ),
      ),
    ),
  ],
),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Text('Welcome, ${widget.name}!', style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 30),
              const Text('Add New User', style: TextStyle(fontSize: 20)),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              DropdownButtonFormField<String>(
                value: _role,
                items: const [
                  DropdownMenuItem(value: 'user', child: Text('User')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
                onChanged: (value) {
                  setState(() {
                    _role = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _addUser,
                      child: const Text('Add User'),
                    ),
              if (_message != null) ...[
                const SizedBox(height: 20),
                Text(
                  _message!,
                  style: TextStyle(
                      color: _message == 'User added successfully'
                          ? Colors.green
                          : Colors.red),
                ),
              ],
            ],
          )),
        ));
  }
}
