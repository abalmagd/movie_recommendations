import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/widgets/button.dart';
import 'package:movie_recommendations/core/widgets/theme_icon_button.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_controller.dart';

class RatingScreen extends ConsumerWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final call = ref.read(movieFlowControllerProvider.notifier);
    final watch = ref.watch(movieFlowControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: call.previousPage),
        actions: [
          ThemeIconButton(onPressed: call.changeTheme),
        ],
      ),
      body: Column(
        children: [
          Text(
            'Select a minimum rating \nranging from 1-10',
            style: theme.textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${watch.rating}',
                style: theme.textTheme.headline2,
              ),
              const Icon(
                Icons.star_rounded,
                color: Colors.amber,
                size: 62,
              ),
            ],
          ),
          const Spacer(),
          Slider(
            label: '${watch.rating}',
            value: watch.rating.toDouble(),
            divisions: 9,
            min: 1,
            max: 10,
            onChanged: (updatedRating) =>
                call.updateRating(updatedRating.toInt()),
          ),
          const Spacer(),
          Button(
            onPressed: call.nextPage,
            text: 'Continue',
          ),
        ],
      ),
    );
  }
}
