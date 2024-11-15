import 'package:flutter/material.dart';

class IsNormalCard extends StatelessWidget {
  const IsNormalCard({this.isNormal = true, super.key});

  final bool isNormal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color green = Colors.green;
    Color red = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: !isNormal ? red.withOpacity(0.1) : green.withOpacity(0.1),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200), // Adjust this value as needed
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              !isNormal ? Icons.arrow_downward : Icons.arrow_upward,
              color: !isNormal ? red : green,
              size: 24,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                !isNormal ? 'Abnormal' : 'Normal',
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: !isNormal ? red : green,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}