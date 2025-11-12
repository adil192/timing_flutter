import 'package:flutter/material.dart';
import 'package:timing_flutter/stows.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Settings",
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(color: colorScheme.onSurface),
        ),
        const SizedBox(height: 16),
        ValueListenableBuilder(
          valueListenable: stows.easyMode,
          builder: (context, _, _) {
            return SettingsCheckbox(
              label: "Easy mode",
              hint:
                  'Keep a constant "off" duration of 1 second rather than the same as the "on" duration.',
              value: stows.easyMode.value,
              onChanged: (value) => stows.easyMode.value = value,
            );
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class SettingsCheckbox extends StatefulWidget {
  const SettingsCheckbox({
    super.key,
    required this.label,
    this.hint = "",
    required this.value,
    this.onChanged,
  });

  final String label;
  final String hint;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  State<SettingsCheckbox> createState() => _SettingsCheckboxState();
}

class _SettingsCheckboxState extends State<SettingsCheckbox> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label),
              Text(widget.hint, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        const Spacer(),
        Checkbox(
          value: widget.value,
          onChanged: (value) => widget.onChanged?.call(value!),
          fillColor: WidgetStateProperty.all(colorScheme.primary),
          checkColor: colorScheme.onPrimary,
        ),
      ],
    );
  }
}
