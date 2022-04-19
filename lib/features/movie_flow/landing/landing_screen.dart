import 'package:flutter/material.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/core/widgets/button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({
    Key? key,
    required this.nextPage,
  }) : super(key: key);

  final VoidCallback nextPage;

  @override
  Widget build(BuildContext context) {
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
            onPressed: nextPage,
            text: 'Get Started',
          ),
          const SizedBox(height: kMediumSpacing),
        ],
      ),
    );
  }
}
