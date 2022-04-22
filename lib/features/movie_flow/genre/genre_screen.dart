import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/core/widgets/button.dart';
import 'package:movie_recommendations/features/movie_flow/genre/list_card.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_controller.dart';

class GenreScreen extends ConsumerWidget {
  const GenreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final read = ref.read(movieFlowControllerProvider);
    final watch = ref.watch(movieFlowControllerProvider);
    final call = ref.read(movieFlowControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: call.previousPage,
        ),
      ),
      body: Column(
        children: [
          Text(
            'Choose a genre!',
            style: theme.textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: kMediumSpacing),
              itemBuilder: (context, index) {
                final genre = watch.genres[index];
                return ListCard(
                  genre: genre,
                  onTap: () => call.toggleSelected(genre),
                );
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: kMediumSpacing),
              itemCount: read.genres.length,
            ),
          ),
          Button(
            onPressed: () {
              call.isGenreSelected()
                  ? call.nextPage()
                  : ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'At least 1 genre must be selected',
                          textAlign: TextAlign.center,
                        ),
                        duration: Duration(milliseconds: 1000),
                        dismissDirection: DismissDirection.none,
                        padding: EdgeInsets.all(kLargeSpacing),
                      ),
                    );
            },
            text: 'Continue',
          ),
          const SizedBox(height: kMediumSpacing),
        ],
      ),
    );
  }
}
