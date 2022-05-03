import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/core/widgets/button.dart';
import 'package:movie_recommendations/core/widgets/theme_icon_button.dart';
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
    final call = ref.read(movieFlowControllerProvider.notifier);
    final watch = ref.watch(movieFlowControllerProvider);
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: call.willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            ThemeIconButton(onPressed: call.changeTheme),
          ],
        ),
        body: watch.movie.when(
          data: (movie) => CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.bottomLeft,
                      children: [
                        _CoverImage(backDropPath: movie.backDropPath),
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
                        style: theme.textTheme.bodyText2,
                      ),
                    ),
                    const SizedBox(height: kSmallSpacing),
                    RichText(
                      text: TextSpan(
                        text: 'Recommended movies based on\n',
                        children: [
                          TextSpan(
                            text: movie.title,
                            style: theme.textTheme.headline5?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                        style: theme.textTheme.headline6,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: kMediumSpacing),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(kMediumSpacing),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 150,
                    crossAxisSpacing: kSmallSpacing,
                    mainAxisSpacing: kSmallSpacing,
                    childAspectRatio: 9 / 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return watch.recommendedMovies.when(
                        data: (recommendedMovies) {
                          final recommendedMovie = recommendedMovies[index];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                Navigator.pushReplacement(
                                    context, ResultScreen.route());
                                call.loadRecommendedMovie(recommendedMovie);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      recommendedMovie.posterPath ?? '',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    recommendedMovie.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyText2?.copyWith(
                                      fontSize:
                                          theme.textTheme.bodySmall?.fontSize,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: kSmallSpacing),
                                    child: Row(
                                      children: [
                                        Text(
                                          recommendedMovie.releaseDate
                                              .substring(0, 4),
                                          style: theme.textTheme.bodyText2
                                              ?.copyWith(
                                            fontSize: theme
                                                .textTheme.bodySmall?.fontSize,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          recommendedMovie.voteAverage
                                                  .toStringAsFixed(1)
                                                  .endsWith('0')
                                              ? '${recommendedMovie.voteAverage.toInt()}'
                                              : recommendedMovie.voteAverage
                                                  .toStringAsFixed(1),
                                          style: theme.textTheme.bodyText2
                                              ?.copyWith(
                                            fontSize: theme
                                                .textTheme.bodySmall?.fontSize,
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
                        error: (e, s) => Text(e.toString()),
                        loading: () => null,
                      );
                    },
                    childCount: watch.recommendedMovies.asData?.value.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                    height: kBottomNavigationBarHeight + kSmallSpacing),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('Error => $e')),
        ),
        floatingActionButton: Button(
          onPressed: () {
            call.goToGenres();
            Navigator.pop(context);
          },
          text: 'Find another movie',
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({
    Key? key,
    this.backDropPath,
  }) : super(key: key);

  final String? backDropPath;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height / 3),
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
        child: Image.network(
          backDropPath ?? '',
          fit: BoxFit.cover,
          errorBuilder: (context, e, s) => const SizedBox(),
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
            child: Image.network(
              movie.posterPath ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, e, s) => const SizedBox(),
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
                  movie.releaseDate.substring(0, 4),
                  style: theme.textTheme.bodyText2,
                ),
                Row(
                  children: [
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
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
