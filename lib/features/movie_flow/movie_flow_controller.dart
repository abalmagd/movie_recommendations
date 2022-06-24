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
        genres: const AsyncValue.data([]),
        movie: AsyncValue.data(Movie.initial()),
        movieVideos: const AsyncValue.data([]),
        otherMovies: const AsyncValue.data([]),
        cast: const AsyncValue.data([]),
        actorMovies: const AsyncValue.data([]),
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
    result.fold(
      (l) => state = state.copyWith(
        genres: AsyncValue.error(l),
      ),
      (r) => state = state.copyWith(
        genres: AsyncValue.data(r),
      ),
    );
  }

  void loadRecommendedMovies(Movie movie) async {
    final recommendedMovies =
        await _movieService.getRecommendedMovies(movie.id);

    recommendedMovies.fold(
      (l) => state = state.copyWith(
        otherMovies: AsyncValue.error(l),
      ),
      (r) => state = state.copyWith(
        otherMovies: AsyncValue.data(r),
      ),
    );
  }

  void loadCast(Movie movie) async {
    final cast = await _movieService.getMovieCast(movie.id);

    cast.fold(
      (l) => state = state.copyWith(
        cast: AsyncValue.error(l),
      ),
      (r) => state = state.copyWith(
        cast: AsyncValue.data(r),
      ),
    );
  }

  Future<void> loadActorMovies(int personId) async {
    state = state.copyWith(
      actorMovies: const AsyncValue.loading(),
    );

    final actorMovies = await _movieService.getActorMovies(personId);

    actorMovies.fold(
      (l) => state = state.copyWith(
        actorMovies: AsyncValue.error(l),
      ),
      (r) => state = state.copyWith(
        actorMovies: AsyncValue.data(r),
      ),
    );
  }

  void loadTrailers(int movieId) async {
    state = state.copyWith(
      movieVideos: const AsyncValue.loading(),
    );

    final movieVideos = await _movieService.getMovieTrailers(movieId);

    movieVideos.fold(
      (l) => state = state.copyWith(
        movieVideos: AsyncValue.error(l),
      ),
      (r) => state = state.copyWith(
        movieVideos: AsyncValue.data(r),
      ),
    );
  }

  Future<void> loadResults() async {
    state = state.copyWith(
      movie: const AsyncValue.loading(),
      otherMovies: const AsyncValue.loading(),
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

    movie.fold(
      (l) => state = state.copyWith(
        movie: AsyncValue.error(l),
      ),
      (r) {
        loadCast(r);
        loadTrailers(r.id);
        loadRecommendedMovies(r);

        state = state.copyWith(
          movie: AsyncValue.data(r),
          scrollController: ScrollController(),
        );
      },
    );
  }

  void changeMovieFromRecommendations(Movie movie) async {
    state = state.copyWith(
      movie: AsyncValue.data(movie),
      otherMovies: const AsyncValue.loading(),
      cast: const AsyncValue.loading(),
    );

    loadRecommendedMovies(movie);

    loadCast(movie);

    loadTrailers(movie.id);
  }

  void changeTheme(BuildContext context) async {
    switch (state.themeMode) {
      case ThemeMode.system:
        if (MediaQuery.of(context).platformBrightness == Brightness.light) {
          state = state.copyWith(
            themeMode: ThemeMode.dark,
          );
        } else {
          state = state.copyWith(
            themeMode: ThemeMode.light,
          );
        }
        break;
      case ThemeMode.light:
        state = state.copyWith(
          themeMode: ThemeMode.dark,
        );
        break;
      case ThemeMode.dark:
        state = state.copyWith(
          themeMode: ThemeMode.light,
        );
        break;
    }
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
