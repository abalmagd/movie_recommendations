import 'package:flutter/material.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/theme/palette.dart';

class CustomTheme {
  static ThemeData darkTheme(BuildContext context) {
    final theme = Theme.of(context);
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: MaterialColor(
          Palette.red500.value,
          const {
            100: Palette.red100,
            200: Palette.red200,
            300: Palette.red300,
            400: Palette.red400,
            500: Palette.red500,
            600: Palette.red600,
            700: Palette.red700,
            800: Palette.red800,
            900: Palette.red900,
          },
        ),
        accentColor: Palette.red500,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: Palette.almostBlack,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Palette.almostBlack,
      ),
      textTheme: theme.primaryTextTheme
          .copyWith(
            button: theme.primaryTextTheme.button?.copyWith(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          )
          .apply(
            displayColor: Colors.white,
          ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kSmallSpacing / 2),
          ),
          backgroundColor: Palette.red500,
        ),
      ),
    );
  }

  static ThemeData lightTheme(BuildContext context) {
    final theme = Theme.of(context);
    return ThemeData(
        // TODO: Add lightTheme
        );
  }
}
