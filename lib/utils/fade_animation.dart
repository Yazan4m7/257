import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
enum AniProps { opacity, translateY }
class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeAnimation(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    ;
    final tween = MultiTween()
      ..add(1, Tween(begin: -130.0, end: 0.0))
      ..add(AniProps.translateY, Tween(begin: -130.0, end: 0.0), Duration(milliseconds: 500), Curves.easeOut);

    return PlayAnimation<MultiTweenValues> (
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
      opacity: animation.get(1),
      child: Transform.translate(
      offset: Offset(0, animation.get(AniProps.translateY)),
      child: child
    ),
    ));
  }
}