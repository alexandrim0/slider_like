import 'package:flutter/material.dart';

class FadeReveal extends StatefulWidget {
  const FadeReveal({
    required this.child,
    this.duration = const Duration(milliseconds: 100),
    super.key,
  });

  final Widget child;
  final Duration duration;

  @override
  FadeRevealState createState() => FadeRevealState();
}

class FadeRevealState extends State<FadeReveal> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: widget.child,
    );
  }
}
