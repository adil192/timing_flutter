
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
  bool blinkOn = true;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(duration: Duration(milliseconds: BlinkCurve.blinkOffMs + widget.blinkOnDuration.inMilliseconds), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: BlinkCurve(blinkOnDuration: widget.blinkOnDuration));
    animation.addListener(() {
      setState(() {});
    });
    controller.forward();
    controller.repeat(reverse: false);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (widget.isBlinking) {
      blinkOn = animation.value == 0;
    } else {
      blinkOn = true;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: blinkOn ? colorScheme.primary : Colors.transparent,
      ),
      child: widget.child,
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
