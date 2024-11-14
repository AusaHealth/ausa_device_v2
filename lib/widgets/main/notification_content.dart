import 'package:flutter/material.dart';

class NotificationContent extends StatelessWidget {
  const NotificationContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Text('No notifications yet!'),
      ),
    );
  }
}