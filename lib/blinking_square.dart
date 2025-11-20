import 'package:flutter/material.dart';
import 'package:timing_flutter/stows.dart';

class BlinkingSquare extends StatefulWidget {
  const BlinkingSquare({
    super.key,
    required this.child,
    this.isBlinking = false,
    this.blinkOnDuration = const Duration(milliseconds: 500),
  });

  final Widget child;
  final bool isBlinking;
  final Duration blinkOnDuration;

  @override
  State<BlinkingSquare> createState() => _BlinkingSquareState();
}

class _BlinkingSquareState extends State<BlinkingSquare>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(vsync: this);
  late _OpacityTween _tween;

  /// Animation that outputs 1 when the square should be visible.
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _updateAnimation();
    stows.easyMode.addListener(_updateAnimation);
  }

  @override
  void dispose() {
    stows.easyMode.removeListener(_updateAnimation);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BlinkingSquare oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isBlinking != oldWidget.isBlinking ||
        widget.blinkOnDuration != oldWidget.blinkOnDuration) {
      _updateAnimation();
    }
  }

  void _updateAnimation() {
    _tween = _OpacityTween(
      blinkOnDuration: widget.blinkOnDuration,
      easyMode: stows.easyMode.value,
    );
    _controller.duration = Duration(milliseconds: _tween.periodMs);
    _opacityAnimation = widget.isBlinking
        ? _tween.animate(_controller)
        : AlwaysStoppedAnimation(1.0);
    _controller.repeat(reverse: false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(
        decoration: ShapeDecoration(
          color: colorScheme.primary,
          shape: RoundedSuperellipseBorder(
            borderRadius: const BorderRadius.all(Radius.circular(32)),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}

class _OpacityTween extends Tween<double> {
  late final int periodMs;
  late final double threshold; // 0 to 1
  _OpacityTween({required Duration blinkOnDuration, required bool easyMode})
    : super(begin: 1, end: 0) {
    final blinkOnMs = blinkOnDuration.inMilliseconds;
    final blinkOffMs = easyMode ? 1000 : blinkOnMs;
    periodMs = blinkOnMs + blinkOffMs;
    threshold = blinkOnMs / periodMs;
  }

  @override
  double lerp(double t) {
    return t < threshold ? begin! : end!;
  }
}
