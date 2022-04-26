import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/widgets/button.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_controller.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final watch = ref.read(movieFlowControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: watch.changeTheme,
            icon: const Icon(Icons.dark_mode),
            // color: watch.themeMode ? Colors.black : Colors.white,
          ),
        ],
      ),
      body: Column(
        children: [
          Text(
            'Let\'s Find a Movie!',
            style: theme.textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          const Expanded(
            child: Image(
              image: AssetImage('images/undraw_netflix_q00o.png'),
            ),
          ),
          Button(
            onPressed: watch.nextPage,
            text: 'Get Started',
          ),
        ],
      ),
    );
  }
}
