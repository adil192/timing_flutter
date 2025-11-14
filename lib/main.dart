import 'package:flutter/material.dart';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:timing_flutter/stows.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:timing_flutter/blinking_square.dart';
import 'package:timing_flutter/settings_dialogue.dart';

import 'dart:math';

const defaultColor = Colors.indigo;

void main() {
  Stows.volatile = false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @visibleForTesting
  static ThemeData createTheme(
    Brightness brightness, [
    ColorScheme? colorScheme,
  ]) {
    colorScheme ??= ColorScheme.fromSeed(
      seedColor: defaultColor,
      brightness: brightness,
    );
    return ThemeData(
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          title: 'Timing Trainer',
          theme: createTheme(Brightness.light, lightDynamic),
          darkTheme: createTheme(Brightness.dark, darkDynamic),
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _actualMs = 500;
  int _guessMs = 0;
  int _sliderValue = 250;

  bool isSubmitted = false;

  static const String submit = "Submit";
  static const String reset = "Reset";

  @override
  initState() {
    super.initState();
    _chooseMs();
  }

  void _chooseMs() {
    _actualMs = (16 + Random().nextInt(30) * 1000 / 60).round();
    if (_actualMs > 500) _actualMs = 500; // fix bug on web
  }

  @visibleForTesting
  void populateTestData(int actualMs, int guessMs) {
    _actualMs = actualMs;
    _guessMs = guessMs;
    _sliderValue = guessMs;
    isSubmitted = true;
    if (mounted) setState(() {});
  }

  void _onSubmit() {
    setState(() {
      isSubmitted = !isSubmitted;
      if (isSubmitted) {
        _guessMs = _sliderValue;
      } else {
        // Reset
        _chooseMs();
      }
    });
  }

  static final _githubUri = Uri.parse(
    "https://github.com/adil192/timing_flutter",
  );
  static final _privacyPolicyUri = Uri.parse(
    "https://adil192.github.io/timing_flutter/privacy-policy.html",
  );
  void _openGithub() => launchUrl(_githubUri);
  void _openPrivacyPolicy() => launchUrl(_privacyPolicyUri);

  void _openSettings() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(content: SettingsDialog()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Timing Trainer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            tooltip: 'Source Code',
            onPressed: _openGithub,
          ),
          IconButton(
            icon: const Icon(Icons.privacy_tip),
            tooltip: 'Privacy Policy',
            onPressed: _openPrivacyPolicy,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: _openSettings,
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
                          style: TextTheme.of(context).displayMedium?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
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
                          ),
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
                  },
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
                      autofocus: true,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                      ),
                      onPressed: _onSubmit,
                      child: Text(
                        isSubmitted ? reset : submit,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
