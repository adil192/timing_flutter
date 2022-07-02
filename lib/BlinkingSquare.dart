
import 'package:flutter/material.dart';

class BlinkingSquare extends StatefulWidget {
  const BlinkingSquare({
    Key? key,
    required this.child,
    this.isBlinking = false,
    this.blinkOnDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  final Widget child;
  final bool isBlinking;
  final Duration blinkOnDuration;

  @override
  _BlinkingSquareState createState() => _BlinkingSquareState();
}

class _BlinkingSquareState extends State<BlinkingSquare> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late CurvedAnimation _animation;

  late Duration _currentDuration;

  bool _blinkOn = true;
  double _lastAnimationValue = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: Duration(milliseconds: BlinkCurve.blinkOffMs + widget.blinkOnDuration.inMilliseconds), vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: BlinkCurve(blinkOnDuration: widget.blinkOnDuration));
    _currentDuration = widget.blinkOnDuration;
    _animation.addListener(() {
      if (_animation.value == _lastAnimationValue) return; // don't setSate if not changed
      setState(() {
        _lastAnimationValue = _animation.value;
      });
    });
    _controller.repeat(reverse: false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.blinkOnDuration != _currentDuration) {
      _currentDuration = widget.blinkOnDuration;
      _controller.duration = Duration(milliseconds: BlinkCurve.blinkOffMs + widget.blinkOnDuration.inMilliseconds);
      _animation.curve = BlinkCurve(blinkOnDuration: widget.blinkOnDuration);
    }

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
  static const int blinkOffMs = 1000;

  late final double threshold; // 0 to 1
  BlinkCurve({required Duration blinkOnDuration}) {
    int blinkOnMs = blinkOnDuration.inMilliseconds;
    threshold = blinkOnMs / (blinkOnMs + blinkOffMs);
  }

  @override
  double transform(double t) {
    return t < threshold ? 0 : 1;
  }
}
