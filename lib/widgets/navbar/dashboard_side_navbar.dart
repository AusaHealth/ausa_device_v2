import 'package:flutter/material.dart';
import 'nav_item.dart';

class CollapsibleSideNavbar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final Widget child;

  const CollapsibleSideNavbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  @override
  State<CollapsibleSideNavbar> createState() => _CollapsibleSideNavbarState();
}

class _CollapsibleSideNavbarState extends State<CollapsibleSideNavbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isExpanded = false;
  
  final double collapsedWidth = 80;
  final double expandedWidth = 250;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleNavbar() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8), 
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final width = Tween<double>(
                begin: collapsedWidth,
                end: expandedWidth,
              ).evaluate(CurvedAnimation(
                parent: _controller,
                curve: Curves.easeInOut,
              ));

              return Container(
                width: width,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16), 
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: IconButton(
                        icon: AnimatedIcon(
                          icon: AnimatedIcons.menu_close,
                          progress: _controller,
                        ),
                        onPressed: _toggleNavbar,
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                    Expanded(
                      child: Center( 
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                            horizontal: _controller.value > 0.5 ? 8 : 4,
                          ),
                          children: [
                            NavItem(
                              label: 'Dashboard',
                              icon: Icons.dashboard_outlined,
                              isSelected: widget.selectedIndex == 0,
                              onTap: () => widget.onDestinationSelected(0),
                              expandProgress: _controller.value,
                            ),
                            const SizedBox(height: 8),
                            NavItem(
                              label: 'Notifications',
                              icon: Icons.notifications_outlined,
                              isSelected: widget.selectedIndex == 1,
                              onTap: () => widget.onDestinationSelected(1),
                              expandProgress: _controller.value,
                            ),
                            const SizedBox(height: 8),
                            NavItem(
                              label: 'Previous Scans',
                              icon: Icons.history,
                              isSelected: widget.selectedIndex == 2,
                              onTap: () => widget.onDestinationSelected(2),
                              expandProgress: _controller.value,
                            ),
                            const SizedBox(height: 8),
                            NavItem(
                              label: 'Help',
                              icon: Icons.help_outline,
                              isSelected: widget.selectedIndex == 3,
                              onTap: () => widget.onDestinationSelected(3),
                              expandProgress: _controller.value,
                            ),
                            const SizedBox(height: 8),
                            NavItem(
                              label: 'Settings',
                              icon: Icons.settings_outlined,
                              isSelected: widget.selectedIndex == 4,
                              onTap: () => widget.onDestinationSelected(4),
                              expandProgress: _controller.value,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Expanded(child: widget.child),
            ],
          ),
        ),
      ],
    );
  }
}