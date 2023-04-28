import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:slider_like/src/fade_reveal.dart';
import 'package:slider_like/src/symmetric_slider.dart';

enum SliderLikeStartBehavior {
  longPress,
  drag,
}

class SliderLike extends StatefulWidget {
  const SliderLike({
    required this.child,
    required this.onLike,
    this.startBehavior = SliderLikeStartBehavior.drag,
    this.size = const Size(20, 200),
    this.thumbSize = const Size.square(28),
    this.backgroundBuilder = SymmetricSlider.defaultBackgroundBuilder,
    this.thumbBuilder = SymmetricSlider.defaultThumbBuilder,
    super.key,
  });

  final Widget child;
  final ValueChanged<double> onLike;
  final SliderLikeStartBehavior startBehavior;
  final Size size;
  final Size thumbSize;
  final WidgetBuilder backgroundBuilder;
  final WidgetBuilder thumbBuilder;

  @override
  SliderLikeState createState() => SliderLikeState();
}

class SliderLikeState extends State<SliderLike> {
  final _positionNotifier = ValueNotifier<Offset?>(null);

  OverlayEntry? _overlayEntry;
  double _likeValue = 0;

  void _onGestureStart(Offset position) {
    _positionNotifier.value = position;
    final startPosition = position;
    final sliderSize = widget.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: startPosition.dx - sliderSize.width / 2,
        top: startPosition.dy - sliderSize.height / 2,
        width: sliderSize.width,
        height: sliderSize.height,
        child: ValueListenableBuilder<Offset?>(
          valueListenable: _positionNotifier,
          builder: (context, position, _) {
            _likeValue = ((startPosition.dy - position!.dy) / (sliderSize.height / 2)).clamp(-1, 1);

            return FadeReveal(
              child: SymmetricSlider(
                thumbSize: widget.thumbSize,
                value: _likeValue,
                backgroundBuilder: widget.backgroundBuilder,
                thumbBuilder: widget.thumbBuilder,
              ),
            );
          },
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _onGestureUpdate(Offset position) {
    _positionNotifier.value = position;
  }

  void _onGestureEnd() {
    widget.onLike(_likeValue);
    _removeOverlay();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _positionNotifier.value = null;
  }

  @override
  void dispose() {
    _positionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.startBehavior) {
      case SliderLikeStartBehavior.longPress:
        return GestureDetector(
          onLongPressStart: (details) => _onGestureStart(details.globalPosition),
          onLongPressEnd: (_) => _onGestureEnd(),
          onLongPressMoveUpdate: (details) => _onGestureUpdate(details.globalPosition),
          child: widget.child,
        );
      case SliderLikeStartBehavior.drag:
        return GestureDetector(
          dragStartBehavior: DragStartBehavior.start,
          onPanDown: (details) => _onGestureStart(details.globalPosition),
          onPanEnd: (_) => _onGestureEnd(),
          onPanCancel: () => _onGestureEnd(),
          onPanUpdate: (details) => _onGestureUpdate(details.globalPosition),
          child: widget.child,
        );
    }
  }
}
