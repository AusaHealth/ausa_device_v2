import 'package:flutter/material.dart';

class UpcomingAppointmentCard extends StatelessWidget {
  const UpcomingAppointmentCard({
    required this.label,
    required this.subtitle,
    required this.timing,
    super.key,
  });

  final String label;
  final String subtitle;
  final String timing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          border: Border.all(
            color: Theme.of(context).primaryColor.withAlpha(50),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(43, 139, 139, 139),
              spreadRadius: 0,
              blurRadius: 12,
              offset: Offset(-4, 8),
            )
          ]),
      padding: const EdgeInsets.symmetric(
        vertical: 28,
        horizontal: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  timing,
                  style: TextStyle(
                    color: Colors.amber[900],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
