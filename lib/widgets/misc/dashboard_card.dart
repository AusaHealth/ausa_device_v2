import 'package:ausa_device_test/widgets/misc/upcoming_appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:ausa_device_test/theme/main_theme.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    required this.title,
    this.label = '',
    this.subtitle = '',
    this.timing = '',
    required this.imagePath,
    this.imageAlignment = Alignment.bottomRight,
    super.key,
  });

  final String title;
  final String label;
  final String subtitle;
  final String timing;
  final String imagePath;
  final Alignment imageAlignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(32),
      child: Card(
        elevation: 0,
        color: theme.colorScheme.cardColorMain,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: Stack(
          children: [
            // Image Background
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Align(
                  alignment: imageAlignment,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    scale: 1.5,
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: theme.colorScheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (label.isNotEmpty)
                    UpcomingAppointmentCard(
                        label: label, subtitle: subtitle, timing: timing),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
