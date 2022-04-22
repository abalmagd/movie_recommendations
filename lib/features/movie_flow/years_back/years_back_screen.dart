import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/core/widgets/button.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_controller.dart';
import 'package:movie_recommendations/features/movie_flow/result/result_screen.dart';

class YearsBackScreen extends ConsumerWidget {
  const YearsBackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final call = ref.read(movieFlowControllerProvider.notifier);
    final watch = ref.watch(movieFlowControllerProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: call.previousPage,
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
                '${watch.yearsBack}',
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
            label: '${watch.yearsBack}',
            value: watch.yearsBack.toDouble(),
            divisions: 30,
            min: 0,
            max: 30,
            onChanged: (updatedYearsBack) =>
                call.updateYearsBack(updatedYearsBack.toInt()),
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
