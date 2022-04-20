import 'package:flutter/material.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/core/widgets/button.dart';
import 'package:movie_recommendations/features/movie_flow/result/result_screen.dart';

class YearsBackScreen extends StatefulWidget {
  const YearsBackScreen({
    Key? key,
    required this.previousPage,
  }) : super(key: key);

  final VoidCallback previousPage;

  @override
  State<YearsBackScreen> createState() => _YearsBackScreenState();
}

class _YearsBackScreenState extends State<YearsBackScreen> {
  double yearsBack = 10;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: widget.previousPage,
        ),
      ),
      body: Column(
        children: [
          Text(
            'How many years back \nshould we check for?',
            style: theme.textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${yearsBack.ceil()}',
                style: theme.textTheme.headline2,
              ),
              Text(
                'Years Back',
                style: theme.textTheme.headline4?.copyWith(
                  color: theme.textTheme.headline4?.color?.withOpacity(0.70),
                ),
              ),
            ],
          ),
          const Spacer(),
          Slider(
            label: '${yearsBack.ceil()}',
            value: yearsBack,
            divisions: 30,
            min: 0,
            max: 30,
            onChanged: (value) {
              setState(() {
                yearsBack = value;
              });
            },
          ),
          const Spacer(),
          Button(
            onPressed: () => Navigator.push(context, ResultScreen.route()),
            text: 'Continue',
          ),
          const SizedBox(height: kMediumSpacing),
        ],
      ),
    );
  }
}
