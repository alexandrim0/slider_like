import 'package:flutter/material.dart';

class SymmetricSlider extends StatelessWidget {
  const SymmetricSlider({
    required this.thumbSize,
    required this.value,
    required this.backgroundBuilder,
    required this.thumbBuilder,
    super.key,
  });

  final Size thumbSize;
  final double value;
  final WidgetBuilder backgroundBuilder;
  final WidgetBuilder thumbBuilder;

  static Widget defaultBackgroundBuilder(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        gradient: LinearGradient(
          colors: [Colors.green, Colors.yellow, Colors.red],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  static Widget defaultThumbBuilder(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        final thumbOverflow = (width - thumbSize.width) / 2;

        final currentThumbOffset = Offset(
          thumbOverflow,
          (height / 2) * (1 - value) - (thumbSize.height / 2),
        );

        return Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            backgroundBuilder(context),
            Positioned(
              width: thumbSize.width,
              height: thumbSize.height,
              top: currentThumbOffset.dy,
              left: currentThumbOffset.dx,
              child: thumbBuilder(context),
            ),
          ],
        );
      },
    );
  }
}
