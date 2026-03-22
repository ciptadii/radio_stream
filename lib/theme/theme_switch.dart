import 'package:flutter/material.dart';

class ThemeSwitch extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onChanged;
  const ThemeSwitch({super.key, required this.isDark, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.light_mode),
        Switch(
          value: isDark,
          onChanged: onChanged,
        ),
        const Icon(Icons.dark_mode),
      ],
    );
  }
}
