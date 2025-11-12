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
  late var _tween = BlinkTween(blinkOnDuration: Duration.zero, easyMode: true);

  /// Animation that outputs true when the square should be visible.
  late var _animation = _tween.animate(_controller);

  @override
  void initState() {
    super.initState();
    _updateAnimation();
    _animation.addListener(_onBlink);
    _controller.repeat(reverse: false);
  }

  @override
  void dispose() {
    _animation.removeListener(_onBlink);
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
    _tween = BlinkTween(
      blinkOnDuration: widget.blinkOnDuration,
      easyMode: stows.easyMode.value,
    );
    _controller.duration = Duration(milliseconds: _tween.periodMs);
    _animation.removeListener(_onBlink);
    _animation = widget.isBlinking
        ? _tween.animate(_controller)
        : AlwaysStoppedAnimation(true);
    _animation.addListener(_onBlink);
  }

  void _onBlink() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: _animation.value ? colorScheme.primary : Colors.transparent,
        ),
        child: widget.child,
      ),
    );
  }
}

class BlinkTween extends Tween<bool> {
  late final int periodMs;
  late final double threshold; // 0 to 1
  BlinkTween({required Duration blinkOnDuration, required bool easyMode})
    : super(begin: true, end: false) {
    final int blinkOnMs = blinkOnDuration.inMilliseconds;
    final int blinkOffMs = easyMode ? 1000 : blinkOnDuration.inMilliseconds;
    periodMs = blinkOnMs + blinkOffMs;
    threshold = blinkOnMs / periodMs;
  }

  @override
  bool lerp(double t) {
    return t < threshold ? begin! : end!;
  }
}
