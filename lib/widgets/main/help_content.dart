import 'package:flutter/material.dart';

class HelpContent extends StatelessWidget {
  const HelpContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Text('Help'),
      ),
    );
  }
}
