import 'package:ausa_device_test/widgets/misc/dashboard_card.dart';
import 'package:ausa_device_test/widgets/misc/previous_scans_card.dart';
import 'package:flutter/material.dart';

class DashboardContentV2 extends StatelessWidget {
  const DashboardContentV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final columnWidth = (constraints.maxWidth - 5) /
                    2; // Equal width for both columns
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // First column with two cards
                    SizedBox(
                      width: columnWidth,
                      child: const Column(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: DashboardCard(
                                title: 'Take your tests',
                                label: '',
                                subtitle: '',
                                timing: '',
                                imagePath: 'assets/images/take_your_tests.png',
                              ),
                            ),
                          ),
                          SizedBox(height: 5), // Spacing between cards
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: DashboardCard(
                                title: 'Connect with\nDoctor',
                                label: 'Upcoming',
                                subtitle: 'Appointment with Dr.Chi',
                                timing: '10 min',
                                imagePath:
                                    'assets/images/connect_with_doctor.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5), // Spacing between columns
                    // Second column with full-height card
                    SizedBox(
                      width: columnWidth,
                      child: const PreviousScansCard(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
