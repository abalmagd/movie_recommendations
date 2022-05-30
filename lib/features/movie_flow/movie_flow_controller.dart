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

    state = state.copyWith(
      genres: AsyncValue.data(result),
    );
  }

  Future<Movie> loadMovie() async {
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

    return movie;
  }

  void loadRecommendedMovies(Movie movie) async {
    _movieService.getRecommendedMovies(movie.id).then((recommendedMovies) {
      state = state.copyWith(
        otherMovies: AsyncValue.data(recommendedMovies),
      );
    });
  }

  void loadCast(Movie movie) async {
    _movieService.getMovieCast(movie.id).then((cast) {
      state = state.copyWith(
        cast: AsyncValue.data(cast),
      );
    });
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

  void loadMovieVideos(int movieId) async {
    state = state.copyWith(
      movieVideos: const AsyncValue.loading(),
    );

    _movieService.getMovieTrailers(movieId).then((videos) {
      state = state.copyWith(
        movieVideos: AsyncValue.data(videos),
      );
      debugPrint(videos.toString());
    });
  }

  Future<void> loadResults() async {
    state = state.copyWith(
      movie: const AsyncValue.loading(),
      otherMovies: const AsyncValue.loading(),
      cast: const AsyncValue.loading(),
    );

    final movie = await loadMovie();

    loadCast(movie);

    loadRecommendedMovies(movie);

    loadMovieVideos(movie.id);
  }

  void changeMovieFromRecommendations(Movie movie) async {
    state = state.copyWith(
      movie: AsyncValue.data(movie),
      otherMovies: const AsyncValue.loading(),
      cast: const AsyncValue.loading(),
    );

    loadRecommendedMovies(movie);

    loadCast(movie);

    loadMovieVideos(movie.id);
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

    /*if (state.themeMode == null) {
      if (ThemeMode.system == Brightness.dark) {
        state = state.copyWith(
          themeMode: ThemeMode.light,
        );
      } else {
        state = state.copyWith(
          themeMode: ThemeMode.dark,
        );
      }
    } else {
      if (state.themeMode == ThemeMode.dark) {
        state = state.copyWith(
          themeMode: ThemeMode.light,
        );
      } else {
        state = state.copyWith(
          themeMode: ThemeMode.dark,
        );
      }
    }*/
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
