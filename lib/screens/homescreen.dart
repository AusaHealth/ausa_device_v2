// import 'package:ausa/widgets/main/dasboard_content3.dart';
import 'package:ausa/widgets/main/notification_content.dart';
import 'package:ausa/widgets/navbar/dashboard_side_navbar.dart';
import 'package:ausa/widgets/main/help_content.dart';
import 'package:ausa/widgets/main/previous_scans_content.dart';
import 'package:flutter/material.dart';
import 'package:ausa/widgets/misc/animated_page_content.dart';
// import 'package:ausa/widgets/main/dashboard_content.dart';
import 'package:ausa/widgets/main/dashboard_content2.dart';
// import 'package:ausa/widgets/main/notification_content.dart';
import 'package:ausa/widgets/main/settings_content.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final PageTransitionType _transitionType = PageTransitionType.slideAndFade;
  final Duration _transitionDuration = const Duration(milliseconds: 200);
  final Curve _transitionCurve = Curves.easeInOut;

  final List<Widget> _pages = const [
    //DashboardContent(),
    // DashboardContentV3(),
    DashboardContentV2(),
    BPMonitor(),
    // NotificationContent(),
    PreviousScansContent(),
    HelpContent(),
    SettingsContent(),
  ];

  void _handleNavigation(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CollapsibleSideNavbar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _handleNavigation,
        child: AnimatedPageContent(
          transitionType: _transitionType,
          duration: _transitionDuration,
          curve: _transitionCurve,
          child: _pages[_selectedIndex],
        ),
      ),
    );
  }
}
