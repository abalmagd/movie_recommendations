import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_controller.dart';
import 'package:movie_recommendations/theme/custom_theme.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Movie Finder',
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme(context),
      themeMode: ref.watch(movieFlowControllerProvider).themeMode,
      darkTheme: CustomTheme.darkTheme(context),
      home: const MovieFlow(),
    );
  }
}
