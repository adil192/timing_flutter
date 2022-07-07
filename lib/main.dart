import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'dart:math';

import 'package:timing_flutter/BlinkingSquare.dart';
import 'package:url_launcher/url_launcher.dart';

const defaultColor = Colors.indigo;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const title = 'Complete example';

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // Otherwise, use fallback schemes.
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: defaultColor,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: defaultColor,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          title: 'Timing Trainer',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
          ),
          themeMode: ThemeMode.system,
          home: const MyHomePage(title: "Timing Trainer"),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _actualMs = 500;
  int _guessMs = 0;
  int _sliderValue = 250;

  bool isSubmitted = false;

  static const String submit = "Submit";
  static const String reset = "Reset";

  static final Uri githubUri = Uri.parse("https://github.com/adil192/timing_flutter");

  @override
  initState() {
    super.initState();
    _chooseMs();
  }

  _chooseMs() {
    _actualMs = (16 + Random().nextInt(30) * 1000 / 60).ceil();
    if (_actualMs > 500) _actualMs = 500; // fix bug on web
  }

  _onSubmit() {
    setState(() {
      isSubmitted = !isSubmitted;
      if (isSubmitted) {
        _guessMs = _sliderValue;
      } else { // Reset
        _chooseMs();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: colorScheme.onPrimary)),
        toolbarHeight: 70,
        backgroundColor: colorScheme.primary,
        actions: <Widget>[
          IconButton(
            icon: const Icon(EvilIcons.sc_github),
            color: colorScheme.onPrimary,
            iconSize: 45,
            onPressed: () {
              launchUrl(
                githubUri,
                mode: LaunchMode.externalApplication,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: SizedBox(
              width: 250,
              child: BlinkingSquare(
                isBlinking: !isSubmitted,
                blinkOnDuration: Duration(milliseconds: _actualMs),
                child: Opacity(
                  opacity: isSubmitted ? 1 : 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 10),
                          Text(
                            '${_actualMs}ms',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headline2?.copyWith(
                              color: colorScheme.onPrimary,
                            )
                          ),
                          const Spacer(),
                          Text(
                            "You were "
                                "${((_guessMs - _actualMs) / (1000 / 60)).round().abs()}"
                                " frames off with your guess of ${_guessMs}ms!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontSize: 16,
                            )
                          ),
                          const Spacer(flex: 10),
                        ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                const Text("How long does the box above appear?"),
                Slider(
                    value: _sliderValue.toDouble(),
                    min: 16,
                    max: 500,
                    divisions: 29,
                    onChanged: (double value) {
                      if (isSubmitted) return;
                      setState(() {
                        _sliderValue = value.round();
                      });
                    }
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${_sliderValue}ms',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) => colorScheme.primary),
                        foregroundColor: MaterialStateProperty.resolveWith((states) => colorScheme.onPrimary),
                        textStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(fontSize: 16)),
                      ),
                      onPressed: _onSubmit,
                      child: Text(isSubmitted ? reset : submit),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
