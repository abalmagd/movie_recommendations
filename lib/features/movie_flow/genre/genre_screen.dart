import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/core/widgets/button.dart';
import 'package:movie_recommendations/core/widgets/theme_icon_button.dart';
import 'package:movie_recommendations/features/movie_flow/genre/list_card.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_controller.dart';

class GenreScreen extends ConsumerWidget {
  const GenreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watch = ref.watch(movieFlowControllerProvider);
    final call = ref.read(movieFlowControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: call.previousPage),
        actions: [
          ThemeIconButton(onPressed: () => call.changeTheme(context)),
        ],
      ),
      body: Column(
        children: [
          Text(
            'Choose a genre!',
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: watch.genres.when(
              data: (genres) {
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: kMediumSpacing),
                  itemBuilder: (context, index) {
                    final genre = genres[index];
                    return ListCard(
                      genre: genre,
                      onTap: () => call.toggleSelectedGenre(genre),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: kMediumSpacing),
                  itemCount: genres.length,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error => $e')),
            ),
          ),
          Button(
            text: 'Continue',
            onPressed: () {
              if (call.isGenreSelected()) {
                call.nextPage();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'At least 1 genre must be selected',
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(milliseconds: 1500),
                    behavior: SnackBarBehavior.floating,
                    dismissDirection: DismissDirection.horizontal,
                    padding: EdgeInsets.all(kLargeSpacing),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
