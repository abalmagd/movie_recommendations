import 'package:flutter/material.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie.dart';

class PosterDetails extends StatelessWidget {
  const PosterDetails({
    Key? key,
    required this.movie,
    required this.posterHeight,
  }) : super(key: key);

  final Movie movie;
  final double posterHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kLargeSpacing),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: posterHeight,
            child: Image.network(
              movie.posterPath ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, e, s) => const Center(
                child: Text('No preview found'),
              ),
            ),
          ),
          const SizedBox(width: kMediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: theme.textTheme.headline6,
                ),
                Text(
                  movie.genresCommaSeparated,
                  style: theme.textTheme.bodyText2,
                ),
                Text(
                  movie.releaseDate,
                  style: theme.textTheme.bodyText2,
                ),
                Row(
                  children: [
                    Text(
                      movie.voteAverage,
                      style: theme.textTheme.bodyText2?.copyWith(
                        color:
                            theme.textTheme.bodyText2?.color?.withOpacity(0.65),
                      ),
                    ),
                    const Icon(
                      Icons.star_rounded,
                      size: 20,
                      color: Colors.amber,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
