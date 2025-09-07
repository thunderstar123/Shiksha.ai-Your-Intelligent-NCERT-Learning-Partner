import 'package:flutter/material.dart';
import 'login_page.dart'; // Import the login page
import 'chatbot_screen.dart'; // Import the chatbot screen

class UserHome extends StatelessWidget {
  final String name;

  const UserHome({super.key, required this.name});

  void _logout(BuildContext context) {
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
        title: const Text('Welcome'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0), // Adjust padding to move it to the top-right
            child: SizedBox(
              width: 130.0,  // Adjust button width
              height: 30.0,  // Adjust button height
              child: ElevatedButton(
                onPressed: () {
                  _logout(context); // Call the logout function
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Change background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  ),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white, // Text color
                    fontSize: 18.0,  // Text size
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, $name!', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatBotScreen(), // Navigate to the chatbot screen
                  ),
                );
              },
              child: const Text('Ask the Chatbot'),
            ),
          ],
        ),
      ),
    );
  }
}
