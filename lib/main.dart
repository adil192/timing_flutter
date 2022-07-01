import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timing Trainer',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: "Timing Trainer"),
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

  int _sliderValue = 250;

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
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Spacer(),
          Center(
            child: SizedBox(
              width: 400,
              height: 400,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  color: colorScheme.primary,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 10),
                    Text("NaN", style: Theme.of(context).textTheme.headline2),
                    const Spacer(),
                    Text("You were NaN frames off with your guess of ${_sliderValue}ms!"),
                    const Spacer(flex: 10),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            child: Column(
              children: [
                Slider(
                    value: _sliderValue.toDouble(),
                    min: 16,
                    max: 500,
                    divisions: 29,
                    onChanged: (double value) {
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
                      child: const Text("Submit"),
                      onPressed: () {  },
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
