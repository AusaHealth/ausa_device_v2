import 'package:flutter/material.dart';

enum PageTransitionType {
  fade,
  scale,
  slide,
  rotation,
  slideAndFade,
  scaleAndFade
}

class AnimatedPageContent extends StatelessWidget {
  final Widget child;
  final PageTransitionType transitionType;
  final Duration duration;
  final Curve curve;

  const AnimatedPageContent({
    super.key,
    required this.child,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      transitionBuilder: (Widget child, Animation<double> animation) {
        switch (transitionType) {
          case PageTransitionType.fade:
            return FadeTransition(
              opacity: animation,
              child: child,
            );

          case PageTransitionType.scale:
            return ScaleTransition(
              scale: animation,
              child: child,
            );

          case PageTransitionType.slide:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );

          case PageTransitionType.rotation:
            return RotationTransition(
              turns: animation,
              child: child,
            );

          case PageTransitionType.slideAndFade:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );

          case PageTransitionType.scaleAndFade:
            return ScaleTransition(
              scale: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(animation),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
        }
      },
      child: KeyedSubtree(
        key: ValueKey<int>(child.hashCode),
        child: child,
      ),
    );
  }
}