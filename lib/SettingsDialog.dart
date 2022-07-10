
import 'package:flutter/material.dart';


class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 200,
      width: 250,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          children: [
            Text("Settings", style: Theme.of(context).textTheme.headline3),
            const Spacer(),
            SettingsCheckbox(
              label: const Text("Easy mode"),
              value: true,
              onChanged: (bool? value) {},
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class SettingsCheckbox extends StatefulWidget {
  const SettingsCheckbox({
    Key? key,
    required this.label,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  final Text label;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  @override
  State<SettingsCheckbox> createState() => _SettingsCheckboxState();
}
class _SettingsCheckboxState extends State<SettingsCheckbox> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: <Widget>[
        widget.label,
        const Spacer(),
        Checkbox(
          value: widget.value,
          onChanged: widget.onChanged
        ),
      ],
    );
  }
}
