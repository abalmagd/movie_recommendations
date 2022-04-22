import 'package:flutter/material.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/core/widgets/button.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  static route({bool fullScreenDialog = false}) => MaterialPageRoute(
        builder: (context) => const ResultScreen(),
        fullscreenDialog: fullScreenDialog,
      );

  final double movieHeight = 150;

  final Movie movie = const Movie(
    title: 'The Hulk',
    overview:
        'Scientist Bruce Banner (Edward Norton) desperately seeks a cure for '
        'the gamma radiation that contaminated his cells and turned him '
        'into The Hulk. Cut off from his true love Betty Ross (Liv Tyler) '
        'and forced to hide from his nemesis, Gen. Thunderbolt Ross '
        '(William Hurt), Banner soon comes face-to-face with a new threat: '
        'a supremely powerful enemy known as The Abomination (Tim Roth).',
    voteAverage: 5,
    genres: [
      Genre(name: 'Action'),
      Genre(name: 'Thrill'),
      Genre(name: 'Fantasy'),
    ],
    releaseDate: '2020-4-22',
    backDropPath: '',
    posterPath: '',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomLeft,
                  children: [
                    const _CoverImage(),
                    Positioned(
                      width: MediaQuery.of(context).size.width,
                      bottom: -(movieHeight / 2),
                      child: _MovieImageDetails(
                        movie: movie,
                        movieHeight: movieHeight,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: movieHeight / 2),
                Padding(
                  padding: const EdgeInsets.all(kMediumSpacing),
                  child: Text(
                    movie.overview,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ],
            ),
          ),
          Button(
            onPressed: () => Navigator.pop(context),
            text: 'Find another movie',
          ),
          const SizedBox(height: kMediumSpacing),
        ],
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 300),
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.transparent,
            ],
          ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
        },
        child: const Placeholder(),
      ),
    );
  }
}

class _MovieImageDetails extends StatelessWidget {
  const _MovieImageDetails({
    Key? key,
    required this.movie,
    required this.movieHeight,
  }) : super(key: key);

  final Movie movie;
  final double movieHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kLargeSpacing),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: movieHeight,
            child: const Placeholder(),
          ),
          const SizedBox(width: kMediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: theme.primaryTextTheme.headline6,
                ),
                Text(
                  movie.genresCommaSeparated,
                  style: theme.primaryTextTheme.bodyText2,
                ),
                Row(
                  children: [
                    Text(
                      '${movie.voteAverage}',
                      style: theme.primaryTextTheme.bodyText2?.copyWith(
                        color: theme.primaryTextTheme.bodyText2?.color
                            ?.withOpacity(0.65),
                      ),
                    ),
                    const Icon(
                      Icons.star_rounded,
                      size: 20,
                      color: Colors.amber,
                    )
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
