import 'package:flutter/material.dart';

/// Login
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          'Login Page',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
