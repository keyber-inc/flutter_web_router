import 'package:flutter/material.dart';

/// 500 Internal Error
class InternalErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Text(
          '500 Internal Error',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
