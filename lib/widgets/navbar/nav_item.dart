// lib/widgets/nav_item.dart
import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final double expandProgress;

  const NavItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.expandProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: isSelected
                ? Theme.of(context).colorScheme.primaryContainer
                : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: expandProgress > 0.5 ? 16 : 12,
                vertical: 12,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: expandProgress > 0.5 
                    ? MainAxisAlignment.start 
                    : MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                    size: 24,
                  ),
                  if (expandProgress > 0.5) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                      size: 24,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}