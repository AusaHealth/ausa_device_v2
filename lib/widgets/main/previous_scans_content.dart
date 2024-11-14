import 'package:flutter/material.dart';

class PreviousScansContent extends StatelessWidget {
  const PreviousScansContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Text('Oops ! No previous scans to show here .'),
      ),
    );
  }
}