import 'package:flutter/material.dart';
import 'package:movie_recommendations/core/widgets/button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({
    Key? key,
    required this.nextPage,
    required this.previousPage,
  }) : super(key: key);

  final VoidCallback nextPage;
  final VoidCallback previousPage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Let\'s Find a Movie!',
            style: theme.textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          const Image(
            image: AssetImage('images/undraw_netflix_q00o.png'),
          ),
          Button(
            onPressed: nextPage,
            text: 'Get Started',
          ),
        ],
      ),
    );
  }
}
