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
  late AnimationController _controller;
  late CurvedAnimation _animation;

  late Duration _currentDuration;

  bool _blinkOn = true;
  double _lastAnimationValue = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 0),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
    resetAnimation();
    _animation.addListener(() {
      // don't setSate if not changed
      if (_animation.value == _lastAnimationValue) return;
      setState(() {
        _lastAnimationValue = _animation.value;
      });
    });
    _controller.repeat(reverse: false);
  }

  void resetAnimation() {
    _currentDuration = widget.blinkOnDuration;
    BlinkCurve curve = BlinkCurve(
      blinkOnDuration: widget.blinkOnDuration,
      easyMode: stows.easyMode.value,
    );
    _animation.curve = curve;
    _controller.duration = Duration(milliseconds: curve.durationMs);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.blinkOnDuration != _currentDuration) resetAnimation();

    ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (widget.isBlinking) {
      _blinkOn = _animation.value == 0;
    } else {
      _blinkOn = true;
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: _blinkOn ? colorScheme.primary : Colors.transparent,
        ),
        child: widget.child,
      ),
    );
  }
}

class BlinkCurve extends Curve {
  late final int durationMs;

  late final double threshold; // 0 to 1
  BlinkCurve({required Duration blinkOnDuration, required bool easyMode}) {
    final int blinkOnMs = blinkOnDuration.inMilliseconds;
    final int blinkOffMs = easyMode ? 1000 : blinkOnDuration.inMilliseconds;
    durationMs = blinkOnMs + blinkOffMs;
    threshold = blinkOnMs / durationMs;
  }

  @override
  double transform(double t) {
    return t < threshold ? 0 : 1;
  }
}
