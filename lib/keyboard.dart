// add keyboard shortcuts to desktop

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsIntent extends Intent {}

final controlS = LogicalKeySet(
  LogicalKeyboardKey.control,
  LogicalKeyboardKey.keyS,
);
final metaS = LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyS);

class GithubIntent extends Intent {}

final controlG = LogicalKeySet(
  LogicalKeyboardKey.control,
  LogicalKeyboardKey.keyG,
);
final metaG = LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyG);

class ShortcutHandler extends StatelessWidget {
  const ShortcutHandler({
    super.key,
    required this.child,
    this.openSettings,
    this.openGithub,
  });

  final Widget child;
  final VoidCallback? openSettings;
  final VoidCallback? openGithub;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      autofocus: true,
      shortcuts: {
        controlS: SettingsIntent(),
        metaS: SettingsIntent(),
        controlG: GithubIntent(),
        metaG: GithubIntent(),
      },
      actions: {
        SettingsIntent: CallbackAction(onInvoke: (e) => openSettings?.call()),
        GithubIntent: CallbackAction(onInvoke: (e) => openGithub?.call()),
      },
      child: child,
    );
  }
}
