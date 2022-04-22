import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/core/widgets/button.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_controller.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(
            'Let\'s Find a Movie!',
            style: theme.textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          const Image(
            image: AssetImage('images/undraw_netflix_q00o.png'),
          ),
          const Spacer(),
          Button(
            onPressed: ref.read(movieFlowControllerProvider.notifier).nextPage,
            text: 'Get Started',
          ),
          const SizedBox(height: kMediumSpacing),
        ],
      ),
    );
  }
}
