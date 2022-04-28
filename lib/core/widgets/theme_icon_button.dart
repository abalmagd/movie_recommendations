import 'package:flutter/material.dart';

class ThemeIconButton extends StatelessWidget {
  const ThemeIconButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.dark_mode),
      splashRadius: 20,
    );
  }
}
