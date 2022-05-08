import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/core/widgets/theme_icon_button.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_controller.dart';
import 'package:movie_recommendations/features/movie_flow/result/widgets/cover_image.dart';
import 'package:movie_recommendations/features/movie_flow/result/widgets/other_movies.dart';

import 'actor.dart';

class PersonResultScreen extends ConsumerWidget {
  const PersonResultScreen({
    Key? key,
    required this.actor,
  }) : super(key: key);

  final Actor actor;
  final double posterHeight = 150;

  static route({bool fullScreenDialog = true, required Actor actor}) =>
      MaterialPageRoute(
        builder: (context) => PersonResultScreen(actor: actor),
        fullscreenDialog: fullScreenDialog,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {});
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
                      CoverImage(backDropPath: actor.profilePath),
                      Positioned(
                        width: MediaQuery.of(context).size.width,
                        bottom: -(posterHeight / 2),
                        child: _ActorPosterDetails(
                          person: actor,
                          posterHeight: posterHeight,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: (posterHeight / 2) + kMediumSpacing),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: kMediumSpacing),
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
                    return OtherMovies(
                      otherMovies: actorMovies,
                      actorScreen: true,
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
            watch.scrollController?.animateTo(
              0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          },
          child: const Icon(Icons.arrow_upward),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _ActorPosterDetails extends StatelessWidget {
  const _ActorPosterDetails({
    Key? key,
    required this.person,
    required this.posterHeight,
  }) : super(key: key);

  final Actor person;
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
