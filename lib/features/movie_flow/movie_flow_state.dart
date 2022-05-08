import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie.dart';
import 'package:movie_recommendations/features/movie_flow/result/person_result/actor.dart';

@immutable
class MovieFlowState extends Equatable {
  const MovieFlowState({
    required this.pageController,
    this.scrollController,
    this.rating = 5,
    this.yearsBack = 10,
    this.themeMode = ThemeMode.system,
    required this.genres,
    required this.movie,
    required this.actorMovies,
    required this.cast,
    required this.otherMovies,
  });

  final PageController pageController;
  final ScrollController? scrollController;
  final int rating;
  final AsyncValue<List<Actor>> cast;
  final AsyncValue<List<Movie>> actorMovies;
  final int yearsBack;
  final AsyncValue<List<Genre>> genres;
  final AsyncValue<Movie> movie;
  final AsyncValue<List<Movie>> otherMovies;
  final ThemeMode themeMode;

  MovieFlowState copyWith({
    PageController? pageController,
    ScrollController? scrollController,
    AsyncValue<List<Movie>>? actorMovies,
    AsyncValue<List<Movie>>? otherMovies,
    int? rating,
    ThemeMode? themeMode,
    int? yearsBack,
    AsyncValue<List<Genre>>? genres,
    AsyncValue<List<Actor>>? cast,
    AsyncValue<Movie>? movie,
  }) {
    return MovieFlowState(
      pageController: pageController ?? this.pageController,
      scrollController: scrollController ?? this.scrollController,
      otherMovies: otherMovies ?? this.otherMovies,
      actorMovies: actorMovies ?? this.actorMovies,
      rating: rating ?? this.rating,
      cast: cast ?? this.cast,
      themeMode: themeMode ?? this.themeMode,
      yearsBack: yearsBack ?? this.yearsBack,
      genres: genres ?? this.genres,
      movie: movie ?? this.movie,
    );
  }

  @override
  List<Object?> get props =>
      [
        otherMovies,
        pageController,
        scrollController,
        actorMovies,
        rating,
        yearsBack,
        genres,
        movie,
        themeMode,
        cast,
      ];
}
