import 'package:flutter/material.dart';

class IsNormalCard extends StatelessWidget {
  const IsNormalCard({this.isNormal = true, super.key});

  final bool isNormal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const Color green = Color(0xFF059669);
    Color red = theme.colorScheme.error;

    return IntrinsicWidth(
      // Added this widget
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: isNormal ? green : red),
          color: !isNormal ? red.withOpacity(0.1) : green.withOpacity(0.1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            !isNormal
                ? Icon(
                    Icons.arrow_downward,
                    color: theme.colorScheme.error,
                    size: 24,
                  )
                : const Icon(
                    Icons.arrow_upward,
                    color: Color(0xFF059669),
                    size: 24,
                  ),
            const SizedBox(width: 8),
            !isNormal
                ? Text(
                    'Abnormal',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Text(
                    'Normal',
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: const Color(0xFF059669),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}