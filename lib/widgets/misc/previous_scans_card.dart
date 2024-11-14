import 'package:ausa/widgets/misc/previous_scans_reading.dart';
import 'package:flutter/material.dart';
import 'package:ausa/theme/main_theme.dart';

class PreviousScansCard extends StatelessWidget {
  const PreviousScansCard({super.key});

  static const List<Map<String, dynamic>> readings = [
    {
      'title': 'Blood Pressure',
      'value': '120/80',
      'unit': 'mmHg',
      'icon': Icons.favorite_border,
      'isNormal': false,
    },
    {
      'title': 'Blood Glucose',
      'value': '95',
      'unit': 'mg/dL',
      'icon': Icons.water_drop_outlined,
      'isNormal': true,
    },
    {
      'title': 'SpO2',
      'value': '98',
      'unit': '%',
      'icon': Icons.air,
      'isNormal': true,
    },
    {
      'title': 'Heart Rate',
      'value': '72',
      'unit': 'bpm',
      'icon': Icons.favorite,
      'isNormal': true,
    },
    {
      'title': 'Temperature',
      'value': '37.2',
      'unit': '°C',
      'icon': Icons.thermostat_outlined,
      'isNormal': false,
    },
  ];

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
          side: const BorderSide(color: Colors.black12, width: 1),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Previous Scans',
                      style: theme.textTheme.displayLarge,
                    ),
                    TextButton(onPressed: () {}, child: const Text("View All"))
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            ...readings.asMap().entries.map((entry) {
                              final reading = entry.value;
                              return Column(
                                children: [
                                  PreviousScansReadingDashboard(
                                    title: reading['title'],
                                    value: reading['value'],
                                    unit: reading['unit'],
                                    icon: reading['icon'],
                                    isNormal: reading['isNormal'],
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    // Top gradient overlay
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              theme.colorScheme.cardColorMain,
                              theme.colorScheme.cardColorMain.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Bottom gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              theme.colorScheme.cardColorMain,
                              theme.colorScheme.cardColorMain.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
