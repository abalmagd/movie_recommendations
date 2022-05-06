import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/core/widgets/button.dart';
import 'package:movie_recommendations/core/widgets/theme_icon_button.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_controller.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie.dart';
import 'package:movie_recommendations/features/movie_flow/result/person_result_screen.dart';

import 'cast.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({Key? key}) : super(key: key);

  final double movieHeight = 150;

  static route({bool fullScreenDialog = true}) => MaterialPageRoute(
        builder: (context) => const ResultScreen(),
        fullscreenDialog: fullScreenDialog,
      );

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
            controller: watch.scrollController,
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
                    SizedBox(height: (movieHeight / 2) + kMediumSpacing),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kMediumSpacing),
                      child: Text(
                        movie.overview,
                        style: theme.textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(kMediumSpacing),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Cast',
                    style: theme.textTheme.headline6,
                  ),
                ),
              ),
              watch.cast.when(
                data: (cast) => _Cast(cast: cast),
                error: (e, s) => Text(e.toString()),
                loading: () => const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 185,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(kMediumSpacing),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Similar Movies',
                    style: theme.textTheme.headline6,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: kMediumSpacing),
                sliver: watch.recommendedMovies.when(
                  data: (recommendedMovies) {
                    if (recommendedMovies.isNotEmpty) {
                      return _RecommendedMovies(
                        recommendedMovies: recommendedMovies,
                        ref: ref,
                      );
                    }
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Text('No similar movies are found'),
                      ),
                    );
                  },
                  error: (e, s) =>
                      SliverToBoxAdapter(child: Text(e.toString())),
                  loading: () => const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                    height: kBottomNavigationBarHeight + kLargeSpacing),
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
  final String? backDropPath;

  const _CoverImage({
    Key? key,
    this.backDropPath,
  }) : super(key: key);

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
  final Movie movie;

  final double movieHeight;

  const _MovieImageDetails({
    Key? key,
    required this.movie,
    required this.movieHeight,
  }) : super(key: key);

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

class _Cast extends ConsumerWidget {
  final List<Cast> cast;

  const _Cast({
    Key? key,
    required this.cast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final call = ref.read(movieFlowControllerProvider.notifier);
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 4,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: kMediumSpacing),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  call.loadActorMovies(cast[index].id);
                  Navigator.pushReplacement(
                      context, PersonResultScreen.route(person: cast[index]));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      cast[index].profilePath ?? '',
                      errorBuilder: (context, e, s) => SizedBox(
                        height: MediaQuery.of(context).size.height / 5,
                        child: const Center(
                          child: Align(
                            child: Text('No preview found'),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      ),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height / 5,
                      width: double.infinity,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cast[index].name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyText2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: kSmallSpacing),
                      child: Text(
                        cast[index].character,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: theme.textTheme.bodyText2?.copyWith(
                          fontSize: theme.textTheme.bodySmall?.fontSize,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          separatorBuilder: (context, index) =>
              const SizedBox(width: kSmallSpacing),
          itemCount: cast.take(10).length,
        ),
      ),
    );
  }
}

class _RecommendedMovies extends StatelessWidget {
  final List<Movie> recommendedMovies;

  final WidgetRef ref;

  const _RecommendedMovies({
    Key? key,
    required this.recommendedMovies,
    required this.ref,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          final recommendedMovie = recommendedMovies[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                watch.scrollController?.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
                call.changeMovieFromRecommendations(recommendedMovie);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      recommendedMovie.posterPath ?? '',
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
                    recommendedMovie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyText2?.copyWith(
                      fontSize: theme.textTheme.bodySmall?.fontSize,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 2,
                    ),
                    child: Row(
                      children: [
                        Text(
                          recommendedMovie.releaseDate,
                          style: theme.textTheme.bodyText2?.copyWith(
                            fontSize: theme.textTheme.bodySmall?.fontSize,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          recommendedMovie.voteAverage,
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
        childCount: recommendedMovies.length,
      ),
    );
  }
}
