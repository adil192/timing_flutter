
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    _awaitPrefs();
  }

  _awaitPrefs() async {
    if (prefs != null) return;
    prefs = await _prefs;
    setState(() {});
  }

  _onChanged(String key, bool? value) async {
    if (value == null) return;
    prefs ??= await _prefs;
    prefs?.setBool(key, value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 200,
      width: 300,
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
              label: "Easy mode",
              hint: 'Keep a constant "off" duration of 1 second rather than the same as the "on" duration.',
              value: prefs?.getBool('easyMode') ?? true,
              onChanged: (bool? value) => _onChanged('easyMode', value),
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
    this.hint = "",
    required this.value,
    this.onChanged,
  }) : super(key: key);

  final String label;
  final String hint;
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.label),
              Text(
                widget.hint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ]
          ),
        ),
        const Spacer(),
        Checkbox(
          value: widget.value,
          onChanged: widget.onChanged
        ),
      ],
    );
  }
}
