import 'package:flutter/material.dart';

/// 404 Not Found
class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Text(
          '404 Not Found',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
