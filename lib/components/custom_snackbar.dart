import 'package:flutter/material.dart';

class CustomSnackbar extends StatelessWidget {
  final String content;
  const CustomSnackbar({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(content),
      duration: Duration(seconds: 3),
    );
  }
}
