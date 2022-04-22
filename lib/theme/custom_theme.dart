import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          backgroundColor: Colors.transparent,
        ),
        textTheme: theme.primaryTextTheme
            .copyWith(
              button: theme.primaryTextTheme.button?.copyWith(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
            .apply(displayColor: Colors.white),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kSmallSpacing / 2),
            ),
            backgroundColor: Palette.red500,
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.grey.shade800,
          thumbColor: Colors.white,
          valueIndicatorColor: Palette.red500,
          inactiveTickMarkColor: Colors.transparent,
          activeTickMarkColor: Colors.transparent,
        ));
  }

  static ThemeData lightTheme(BuildContext context) {
    final theme = Theme.of(context);
    return ThemeData(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: MaterialColor(
          Palette.blue500.value,
          const {
            100: Palette.blue100,
            200: Palette.blue200,
            300: Palette.blue300,
            400: Palette.blue400,
            500: Palette.blue500,
            600: Palette.blue600,
            700: Palette.blue700,
            800: Palette.blue800,
            900: Palette.blue900,
          },
        ),
        accentColor: Palette.blue500,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Palette.grey200,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Palette.grey200,
        iconTheme: IconThemeData(color: Colors.black),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        ),
      ),
      textTheme: theme.primaryTextTheme.copyWith(
        button: theme.primaryTextTheme.button?.copyWith(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        headline2: theme.primaryTextTheme.headline2?.copyWith(
          color: Colors.black,
        ),
        headline4: theme.primaryTextTheme.headline4?.copyWith(
          color: Colors.black,
        ),
        headline5: theme.primaryTextTheme.headline5?.copyWith(
          color: Colors.black,
        ),
        headline6: theme.primaryTextTheme.headline6?.copyWith(
          color: Colors.black,
        ),
        bodyText2: theme.primaryTextTheme.bodyText2?.copyWith(
          color: Colors.black,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kSmallSpacing / 2),
          ),
          backgroundColor: Palette.blue500,
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: Palette.blue500,
        inactiveTrackColor: Colors.grey,
        thumbColor: Palette.blue500,
        valueIndicatorColor: Palette.almostBlack,
        inactiveTickMarkColor: Colors.transparent,
        activeTickMarkColor: Colors.transparent,
      ),
    );
  }
}
