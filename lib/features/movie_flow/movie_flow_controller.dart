import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_state.dart';
import 'package:movie_recommendations/features/movie_flow/movie_service.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie.dart';

final movieFlowControllerProvider =
    StateNotifierProvider.autoDispose<MovieFlowController, MovieFlowState>(
  (ref) {
    return MovieFlowController(
      MovieFlowState(
        pageController: PageController(),
        movie: AsyncValue.data(Movie.initial()),
        cast: const AsyncValue.data([]),
        genres: const AsyncValue.data([]),
        actorMovies: const AsyncValue.data([]),
        recommendedMovies: const AsyncValue.data([]),
      ),
      ref.watch(movieServiceProvider),
    );
  },
);

class MovieFlowController extends StateNotifier<MovieFlowState> {
  MovieFlowController(MovieFlowState state, this._movieService) : super(state) {
    loadGenres();
  }

  final MovieService _movieService;

  @override
  void dispose() {
    state.pageController.dispose();
    state.scrollController?.dispose();
    super.dispose();
  }

  void loadGenres() async {
    state = state.copyWith(
      genres: const AsyncValue.loading(),
    );

    final result = await _movieService.getGenres();

    state = state.copyWith(
      genres: AsyncValue.data(result),
    );
  }

  void loadActorMovies(int personId) {
    state = state.copyWith(
      actorMovies: const AsyncValue.loading(),
    );

    _movieService.getActorMovies(personId).then(
          (actorMovies) => state = state.copyWith(
            actorMovies: AsyncValue.data(actorMovies),
          ),
        );
  }

  Future<void> loadResults() async {
    state = state.copyWith(
      movie: const AsyncValue.loading(),
      recommendedMovies: const AsyncValue.loading(),
      cast: const AsyncValue.loading(),
    );

    final selectedGenres = state.genres.asData?.value
        .where((e) => e.isSelected)
        .toList(growable: false);

    final movie = await _movieService.getMovie(
      state.rating,
      selectedGenres!,
      state.yearsBack,
    );

    state = state.copyWith(
      movie: AsyncValue.data(movie),
      scrollController: ScrollController(),
    );

    _movieService.getRecommendedMovies(movie.id).then((recommendedMovies) {
      state = state.copyWith(
        recommendedMovies: AsyncValue.data(recommendedMovies),
      );
    });

    _movieService.getMovieCast(movie.id).then((cast) {
      state = state.copyWith(
        cast: AsyncValue.data(cast),
      );
    });
  }

  void changeMovieFromRecommendations(Movie movie) async {
    state = state.copyWith(
      movie: AsyncValue.data(movie),
      recommendedMovies: const AsyncValue.loading(),
      cast: const AsyncValue.loading(),
    );

    final recommendedMovies =
        await _movieService.getRecommendedMovies(movie.id);

    final cast = await _movieService.getMovieCast(movie.id);

    state = state.copyWith(
      movie: AsyncValue.data(movie),
      recommendedMovies: AsyncValue.data(recommendedMovies),
      cast: AsyncValue.data(cast),
    );
  }

  void changeTheme() async {
    state = state.copyWith(
      themeMode: !state.themeMode,
    );
  }

  void toggleSelectedGenre(Genre genre) {
    state = state.copyWith(
      genres: AsyncValue.data([
        for (final oldGenre in state.genres.asData!.value)
          if (oldGenre == genre) oldGenre.toggleSelected() else oldGenre
      ]),
    );
  }

  void updateRating(int updatedRating) {
    state = state.copyWith(
      rating: updatedRating,
    );
  }

  void updateYearsBack(int updatedYearsBack) {
    state = state.copyWith(
      yearsBack: updatedYearsBack,
    );
  }

  bool isGenreSelected() =>
      state.genres.asData!.value.any((element) => element.isSelected);

  void nextPage() {
    if (state.pageController.page! >= 1) {
      if (!isGenreSelected()) {
        return;
      }
    }
    state.pageController.nextPage(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  void previousPage() {
    state.pageController.previousPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic);
  }

  void goToGenres() => state.pageController.jumpToPage(1);

  Future<bool> willPopCallback() async {
    goToGenres();
    return true;
  }
}
