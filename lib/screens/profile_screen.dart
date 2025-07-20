import 'package:flutter/material.dart';

/// Profile screen showing user information
class ProfileScreen extends StatelessWidget {
  /// Constructor
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}