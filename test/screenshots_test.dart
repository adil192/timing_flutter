import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:timing_flutter/main.dart';

void main() {
  group('Screenshot:', () {
    _screenshot(
      '1_guess',
      home: const MyHomePage(),
      beforeScreenshot: (tester) async {
        final state = tester.state<MyHomePageState>(find.byType(MyHomePage));
        state.populateTestData(417, 400);
      },
    );

    _screenshot(
      '2_settings',
      home: const MyHomePage(),
      beforeScreenshot: (tester) async {
        final state = tester.state<MyHomePageState>(find.byType(MyHomePage));
        state.populateTestData(417, 400);
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pump();
      },
    );
  });
}

void _screenshot(
  String description, {
  required Widget home,
  ScreenshotFrameColors frameColors = const ScreenshotFrameColors(
    topBarIconBrightness: .light,
    gestureHintBrightness: .dark,
  ),
  Future<void> Function(WidgetTester tester)? beforeScreenshot,
}) {
  group(description, () {
    for (final goldenDevice in GoldenScreenshotDevices.values) {
      testGoldens('on ${goldenDevice.name}', (tester) async {
        final device = goldenDevice.device;

        await tester.pumpWidget(
          ScreenshotApp.withConditionalTitlebar(
            device: device,
            title: 'Timing Trainer',
            frameColors: frameColors,
            theme: MyApp.createTheme(.light, platform: device.platform),
            home: home,
          ),
        );

        await beforeScreenshot?.call(tester);

        await tester.loadAssets();

        await tester.pumpFrames(
          tester.widget(find.byType(ScreenshotApp)),
          const Duration(seconds: 1),
        );

        await tester.expectScreenshot(device, description);
      });
    }
  });
}
