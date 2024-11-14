import 'package:flutter/material.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 40, 26, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.bluetooth),
          SizedBox(width: 16),
          Icon(Icons.wifi),
          SizedBox(width: 16),
          Icon(Icons.battery_full),
        ],
      ),
    );
  }
}
