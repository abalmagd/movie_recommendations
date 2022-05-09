import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/core/widgets/button.dart';
import 'package:movie_recommendations/core/widgets/theme_icon_button.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_controller.dart';
import 'package:movie_recommendations/features/movie_flow/result/person_result/person_result_screen.dart';
import 'package:movie_recommendations/features/movie_flow/result/trailer.dart';
import 'package:movie_recommendations/features/movie_flow/result/widgets/cover_image.dart';
import 'package:movie_recommendations/features/movie_flow/result/widgets/other_movies.dart';
import 'package:movie_recommendations/features/movie_flow/result/widgets/poster_image_details.dart';

import 'person_result/actor.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({Key? key}) : super(key: key);

  final double posterHeight = 150;

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
            ThemeIconButton(onPressed: () => call.changeTheme(context)),
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
                        CoverImage(backDropPath: movie.backDropPath),
                        Positioned(
                          width: MediaQuery.of(context).size.width,
                          bottom: -(posterHeight / 2),
                          child: PosterDetails(
                            movie: movie,
                            posterHeight: posterHeight,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: (posterHeight / 2) + kMediumSpacing),
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
                    'Videos',
                    style: theme.textTheme.headline6,
                  ),
                ),
              ),
              watch.movieVideos.when(
                data: (videos) => _Trailers(videos: videos),
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
                sliver: watch.otherMovies.when(
                  data: (recommendedMovies) {
                    if (recommendedMovies.isNotEmpty) {
                      return OtherMovies(otherMovies: recommendedMovies);
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

class _Trailers extends StatelessWidget {
  const _Trailers({
    Key? key,
    required this.videos,
  }) : super(key: key);

  final List<Trailer> videos;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 8,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: kMediumSpacing),
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return const SizedBox(
              width: 150,
              child: Placeholder(),
            );
          },
          separatorBuilder: (context, index) =>
              const SizedBox(width: kSmallSpacing),
          itemCount: videos.take(1).length,
        ),
      ),
    );
  }
}

class _Cast extends ConsumerWidget {
  const _Cast({
    Key? key,
    required this.cast,
  }) : super(key: key);

  final List<Actor> cast;

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
          itemBuilder: (context, index) {
            final actor = cast[index];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  call.loadActorMovies(actor.id);
                  Navigator.pushReplacement(
                    context,
                    PersonResultScreen.route(actor: actor),
                  );
                },
                child: SizedBox(
                  width: 125,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.network(
                          actor.profilePath ?? '',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, e, s) => SizedBox(
                            height: MediaQuery.of(context).size.height / 5,
                            child: const Center(
                              child: Align(
                                child: Text('No preview found'),
                                alignment: Alignment.centerLeft,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        actor.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyText2,
                      ),
                      Text(
                        actor.character,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: theme.textTheme.bodyText2?.copyWith(
                          fontSize: theme.textTheme.bodySmall?.fontSize,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) =>
              const SizedBox(width: kSmallSpacing),
          itemCount: cast.take(10).length,
        ),
      ),
    );
  }
}
