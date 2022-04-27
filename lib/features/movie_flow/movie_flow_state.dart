import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie.dart';

@immutable
class MovieFlowState extends Equatable {
  const MovieFlowState({
    required this.pageController,
    this.rating = 5,
    this.yearsBack = 10,
    this.themeMode = false,
    required this.genres,
    required this.movie,
    required this.similarMovies,
  });

  final PageController pageController;
  final int rating;
  final int yearsBack;
  final AsyncValue<List<Genre>> genres;
  final AsyncValue<Movie> movie;
  final AsyncValue<List<Movie>> similarMovies;
  final bool themeMode;

  MovieFlowState copyWith({
    PageController? pageController,
    AsyncValue<List<Movie>>? similarMovies,
    int? rating,
    bool? themeMode,
    int? yearsBack,
    AsyncValue<List<Genre>>? genres,
    AsyncValue<Movie>? movie,
  }) {
    return MovieFlowState(
      pageController: pageController ?? this.pageController,
      similarMovies: similarMovies ?? this.similarMovies,
      rating: rating ?? this.rating,
      themeMode: themeMode ?? this.themeMode,
      yearsBack: yearsBack ?? this.yearsBack,
      genres: genres ?? this.genres,
      movie: movie ?? this.movie,
    );
  }

  @override
  List<Object?> get props => [
        similarMovies,
        pageController,
        rating,
        yearsBack,
        genres,
        movie,
      ];
}
