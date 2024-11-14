import 'package:ausa_device_test/widgets/misc/dashboard_card.dart';
import 'package:ausa_device_test/widgets/misc/previous_scans_card.dart';
import 'package:flutter/material.dart';

class DashboardContentV3 extends StatelessWidget {
  const DashboardContentV3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                const previousScansWidth = 350.0;
                final firstColumnWidth = totalWidth - previousScansWidth - 5;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: firstColumnWidth,
                      child: const Column(
                        children: [
                          // First row of cards - View Reports takes 3/4
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2, // 1/4 width
                                  child: DashboardCard(
                                    title: 'Take your tests',
                                    imagePath:
                                        'assets/images/take_your_tests.png',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  flex: 3, // 3/4 width
                                  child: DashboardCard(
                                    title: 'View Reports',
                                    imagePath:
                                        'assets/images/take_your_tests.png',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          // Second row of cards - Connect with Doctor takes 3/4
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3, // 3/4 width
                                  child: DashboardCard(
                                    title: 'Connect with\nDoctor',
                                    label: 'Upcoming',
                                    subtitle: 'Call with Dr.Chi',
                                    timing: 'in 10 mins',
                                    imagePath:
                                        'assets/images/connect_with_doctor.png',
                                  ),
                                ),
                                SizedBox(width: 5),
                                Expanded(
                                  flex: 2, // 1/4 width
                                  child: DashboardCard(
                                    title: 'Health Tips',
                                    imagePath:
                                        'assets/images/connect_with_doctor.png',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    // PreviousScansCard with fixed width
                    const SizedBox(
                      width: previousScansWidth,
                      child: PreviousScansCard(),
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
