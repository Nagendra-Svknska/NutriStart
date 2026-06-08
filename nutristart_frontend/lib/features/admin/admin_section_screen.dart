import 'package:flutter/material.dart';

class AdminSectionScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const AdminSectionScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Icon(
          icon,
          size: 72,
        ),
      ),
    );
  }
}
