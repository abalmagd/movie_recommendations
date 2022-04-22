import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendations/features/movie_flow/movie_flow_state.dart';

final movieFlowControllerProvider =
    StateNotifierProvider.autoDispose<MovieFlowController, MovieFlowState>(
  (ref) {
    return MovieFlowController(
      MovieFlowState(
        pageController: PageController(),
      ),
    );
  },
);

class MovieFlowController extends StateNotifier<MovieFlowState> {
  MovieFlowController(MovieFlowState state) : super(state);

  @override
  void dispose() {
    state.pageController.dispose();
    super.dispose();
  }

  void toggleSelected(Genre genre) {
    state = state.copyWith(
      genres: [
        for (final oldGenre in state.genres)
          if (oldGenre == genre) oldGenre.toggleSelected() else oldGenre
      ],
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

  bool isGenreSelected() => state.genres.any((element) => element.isSelected);

  void nextPage() {
    if (state.pageController.page! >= 1) {
      if (!isGenreSelected()) {
        return;
      }
    }
    state.pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic);
  }

  void previousPage() {
    state.pageController.previousPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic);
  }

  void goToGenres() {
    state.pageController.jumpToPage(1);
  }
}
