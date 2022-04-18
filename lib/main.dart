import 'package:flutter/material.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow.dart';
import 'package:movie_recommendations/theme/custom_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Recommendations',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme(context),
      themeMode: ThemeMode.dark,
      darkTheme: CustomTheme.darkTheme(context),
      home: const MovieFlow(),
    );
  }
}