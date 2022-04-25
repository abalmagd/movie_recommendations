import 'package:flutter/material.dart';
import 'package:movie_recommendations/core/constants.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.onPressed,
    required this.text,
    this.width = double.infinity,
    this.isLoading = false,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String text;
  final double width;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kMediumSpacing,
        vertical: kMediumSpacing,
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size(width, 48),
        ),
        onPressed: onPressed,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: Theme.of(context).textTheme.button,
              ),
      ),
    );
  }
}
