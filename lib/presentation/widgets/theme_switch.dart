import 'package:flutter/material.dart';

class ThemeSwitch extends StatelessWidget {
  final bool isDark;
  final VoidCallback onChanged;

  const ThemeSwitch({super.key, required this.isDark, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.light_mode),
        Switch(value: isDark, onChanged: (_) => onChanged()),
        const Icon(Icons.dark_mode),
      ],
    );
  }
}
