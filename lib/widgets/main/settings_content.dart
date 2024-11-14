import 'package:ausa/theme/main_theme.dart';
import 'package:flutter/material.dart';

class SettingsContent extends StatelessWidget {
  const SettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.cardColorMain,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Text Styles',
                    style: textTheme.displaySmall,
                  ),
                  const SizedBox(height: 24),
                  _buildTextStyleCard(
                    context: context,
                    name: 'Display Large',
                    style: textTheme.displayLarge!,
                    example: 'Hello World',
                  ),
                  _buildTextStyleCard(
                    context: context,
                    name: 'Display Medium',
                    style: textTheme.displayMedium!,
                    example: 'Hello World',
                  ),
                  _buildTextStyleCard(
                    context: context,
                    name: 'Display Small',
                    style: textTheme.displaySmall!,
                    example: 'Hello World',
                  ),
                  _buildTextStyleCard(
                    context: context,
                    name: 'Body Large',
                    style: textTheme.bodyLarge!,
                    example: 'Hello World',
                  ),
                  _buildTextStyleCard(
                    context: context,
                    name: 'Body Medium',
                    style: textTheme.bodyMedium!,
                    example: 'Hello World',
                  ),
                  _buildTextStyleCard(
                    context: context,
                    name: 'Label Large',
                    style: textTheme.labelLarge!,
                    example: 'Hello World',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextStyleCard({
    required BuildContext context,
    required String name,
    required TextStyle style,
    required String example,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.backgroundPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            example,
            style: style,
          ),
          const SizedBox(height: 8),
          Text(
            'Size: ${style.fontSize?.toStringAsFixed(1)} • Weight: ${style.fontWeight.toString().split('.').last}',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}