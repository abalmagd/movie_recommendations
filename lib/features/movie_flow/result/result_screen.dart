import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/core/widgets/button.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_controller.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({Key? key}) : super(key: key);

  static route({bool fullScreenDialog = true}) => MaterialPageRoute(
        builder: (context) => const ResultScreen(),
        fullscreenDialog: fullScreenDialog,
      );

  final double movieHeight = 150;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final read = ref.read(movieFlowControllerProvider);
    final call = ref.read(movieFlowControllerProvider.notifier);
    return WillPopScope(
      onWillPop: call.willPopCallback,
      child: Scaffold(
        appBar: AppBar(),
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
                          movie: read.movie,
                          movieHeight: movieHeight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: movieHeight / 2),
                  Padding(
                    padding: const EdgeInsets.all(kMediumSpacing),
                    child: Text(
                      read.movie.overview,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
            ),
            Button(
              onPressed: () {
                call.goToGenres();
                Navigator.pop(context);
              },
              text: 'Find another movie',
            ),
            const SizedBox(height: kMediumSpacing),
          ],
        ),
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 231,
      ),
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
        child: const Image(
          image: NetworkImage(
              'https://image.tmdb.org/t/p/original/rr7E0NoGKxvbkb89eR1GwfoYjpA.jpg'),
        ),
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
            child: const Image(
              image: NetworkImage(
                  'https://image.tmdb.org/t/p/original/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg'),
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
                Row(
                  children: [
                    Text(
                      '${movie.voteAverage}',
                      style: theme.textTheme.bodyText2?.copyWith(
                        color:
                            theme.textTheme.bodyText2?.color?.withOpacity(0.65),
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
