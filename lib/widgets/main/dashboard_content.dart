import 'package:ausa_device_test/widgets/misc/dashboard_card.dart';
import 'package:flutter/material.dart';
// import 'package:ausa_device_test/data/dashboard_content.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double itemHeight =
                    (constraints.maxHeight - 5) / 2; // 5 is mainAxisSpacing
                final double itemWidth =
                    (constraints.maxWidth - 5) / 2; // 5 is crossAxisSpacing

                return GridView(
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: itemWidth / itemHeight,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  children: const [
                    DashboardCard(
                        title: 'Take your tests',
                        label: '',
                        subtitle: '',
                        timing: '',
                        imagePath: 'assets/images/take_your_tests.png'),
                    DashboardCard(
                        title: 'View previous\n Scans',
                        label: '',
                        subtitle: '',
                        timing: '',
                        imagePath: 'assets/images/take_your_tests.png'),
                    DashboardCard(
                        title: 'Connect with\nDoctor',
                        label: 'Upcoming',
                        subtitle: 'Call with Dr.Chi',
                        timing: 'in 10 mins',
                        imagePath: 'assets/images/connect_with_doctor.png'),
                    DashboardCard(
                        title: 'Health Score',
                        label: '',
                        subtitle: '',
                        timing: '',
                        imagePath: 'assets/images/take_your_tests.png'),
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
