import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/core/widgets/theme_icon_button.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_controller.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie.dart';
import 'package:movie_recommendations/features/movie_flow/result/result_screen.dart';

import 'cast.dart';

class PersonResultScreen extends ConsumerWidget {
  const PersonResultScreen({
    Key? key,
    required this.person,
  }) : super(key: key);

  final Cast person;
  final double castHeight = 150;

  static route({bool fullScreenDialog = true, required Cast person}) =>
      MaterialPageRoute(
        builder: (context) => PersonResultScreen(person: person),
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
        body: CustomScrollView(
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
                      _CoverImage(backDropPath: person.profilePath),
                      Positioned(
                        width: MediaQuery.of(context).size.width,
                        bottom: -(castHeight / 2),
                        child: _MovieImageDetails(
                          person: person,
                          castHeight: castHeight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: (castHeight / 2) + kMediumSpacing),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: kSmallSpacing),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Actor Movies',
                  style: theme.textTheme.headline6,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(kMediumSpacing),
              sliver: watch.actorMovies.when(
                data: (actorMovies) {
                  if (actorMovies.isNotEmpty) {
                    return _ActorMovies(
                      actorMovies: actorMovies,
                      ref: ref,
                    );
                  }
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text('Error'),
                    ),
                  );
                },
                error: (e, s) => SliverToBoxAdapter(child: Text(e.toString())),
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            watch.scrollController?.animateTo(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease);
          },
          child: const Icon(Icons.arrow_upward),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
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
          height: height / 4,
          width: double.infinity,
          errorBuilder: (context, e, s) => const SizedBox(),
        ),
      ),
    );
  }
}

class _MovieImageDetails extends StatelessWidget {
  final Cast person;

  final double castHeight;

  const _MovieImageDetails({
    Key? key,
    required this.person,
    required this.castHeight,
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
            height: castHeight,
            child: Image.network(
              person.profilePath ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, e, s) => const SizedBox(),
            ),
          ),
          const SizedBox(width: kMediumSpacing),
          Expanded(
            child: Text(
              person.name,
              style: theme.textTheme.headline6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActorMovies extends StatelessWidget {
  final List<Movie> actorMovies;

  final WidgetRef ref;

  const _ActorMovies({
    Key? key,
    required this.actorMovies,
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
          final actorMovie = actorMovies[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                call.changeMovieFromRecommendations(actorMovie);
                Navigator.pushReplacement(context, ResultScreen.route());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.network(
                      actorMovie.posterPath ?? '',
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
                    actorMovie.title,
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
                          actorMovie.releaseDate,
                          style: theme.textTheme.bodyText2?.copyWith(
                            fontSize: theme.textTheme.bodySmall?.fontSize,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          actorMovie.voteAverage,
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
        childCount: actorMovies.length,
      ),
    );
  }
}
