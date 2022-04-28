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
        genres: const AsyncValue.data([]),
        similarMovies: const AsyncValue.data([]),
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
    super.dispose();
  }

  Future<void> changeTheme() async {
    state = state.copyWith(
      themeMode: !state.themeMode,
    );
  }

  Future<void> loadGenres() async {
    state = state.copyWith(
      genres: const AsyncValue.loading(),
    );

    final result = await _movieService.getGenres();

    state = state.copyWith(
      genres: AsyncValue.data(result),
    );
  }

  Future<void> loadMovie() async {
    state = state.copyWith(
      movie: const AsyncValue.loading(),
      similarMovies: const AsyncValue.loading(),
    );
    final selectedGenres = state.genres.asData?.value
        .where((e) => e.isSelected)
        .toList(growable: false);

    final result = await _movieService.getRecommendedMovie(
        state.rating, selectedGenres ?? [], state.yearsBack);

    final similarMovies = await _movieService.getSimilarMovies(result.id);

    state = state.copyWith(
      movie: AsyncValue.data(result),
      similarMovies: AsyncValue.data(similarMovies),
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
