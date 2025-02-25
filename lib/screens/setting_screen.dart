import 'package:flutter/material.dart';
import 'package:flutter_task/screens/login_screen.dart';
import 'package:flutter_task/services/auth_service.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  void _logout(BuildContext context) {
    AuthService.logout().then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _logout(context), // Call logout function
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Red color for logout button
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
          child: const Text(
            "Logout",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
