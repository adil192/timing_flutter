
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

  late AnimationController controller;
  late CurvedAnimation animation;

  late Duration currentDuration;

  bool blinkOn = true;
  double lastAnimationValue = 0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(milliseconds: BlinkCurve.blinkOffMs + widget.blinkOnDuration.inMilliseconds), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: BlinkCurve(blinkOnDuration: widget.blinkOnDuration));
    currentDuration = widget.blinkOnDuration;
    animation.addListener(() {
      if (animation.value == lastAnimationValue) return; // don't setSate if not changed
      setState(() {
        lastAnimationValue = animation.value;
      });
    });
    controller.forward();
    controller.repeat(reverse: false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.blinkOnDuration != currentDuration) {
      currentDuration = widget.blinkOnDuration;
      controller.duration = Duration(milliseconds: BlinkCurve.blinkOffMs + widget.blinkOnDuration.inMilliseconds);
      animation.curve = BlinkCurve(blinkOnDuration: widget.blinkOnDuration);
    }

    ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (widget.isBlinking) {
      blinkOn = animation.value == 0;
    } else {
      blinkOn = true;
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: blinkOn ? colorScheme.primary : Colors.transparent,
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
