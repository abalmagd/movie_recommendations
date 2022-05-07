import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_controller.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie.dart';

class OtherMovies extends ConsumerWidget {
  final List<Movie> otherMovies;

  const OtherMovies({
    Key? key,
    required this.otherMovies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final call = ref.read(movieFlowControllerProvider.notifier);
    final watch = ref.watch(movieFlowControllerProvider);
    final theme = Theme.of(context);
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        crossAxisSpacing: kSmallSpacing,
        mainAxisSpacing: kSmallSpacing,
        childAspectRatio: 9 / 16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final movie = otherMovies[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                watch.scrollController?.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
                call.changeMovieFromRecommendations(movie);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      movie.posterPath ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, e, s) => const Center(
                        child: Align(
                          child: Text('No preview found'),
                          alignment: Alignment.centerLeft,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyText2?.copyWith(
                      fontSize: theme.textTheme.bodySmall?.fontSize,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Row(
                      children: [
                        Text(
                          movie.releaseDate,
                          style: theme.textTheme.bodyText2?.copyWith(
                            fontSize: theme.textTheme.bodySmall?.fontSize,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          movie.voteAverage,
                          style: theme.textTheme.bodyText2?.copyWith(
                            fontSize: theme.textTheme.bodySmall?.fontSize,
                          ),
                        ),
                        const Icon(
                          Icons.star_rounded,
                          size: kMediumSpacing,
                          color: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: otherMovies.length,
      ),
    );
  }
}
