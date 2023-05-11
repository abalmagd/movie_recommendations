import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie.dart';
import 'package:movie_recommendations/features/movie_flow/result/person_result/actor.dart';
import 'package:movie_recommendations/features/movie_flow/result/video_player/trailer.dart';

@immutable
class MovieFlowState extends Equatable {
  const MovieFlowState({
    this.themeMode = ThemeMode.system,
    required this.pageController,
    required this.genres,
    this.rating = 5,
    this.yearsBack = 10,
    this.scrollController,
    required this.movie,
    required this.movieVideos,
    required this.cast,
    required this.otherMovies,
    required this.actorMovies,
  });

  final ThemeMode themeMode;
  final PageController pageController;
  final AsyncValue<List<Genre>> genres;
  final int rating;
  final int yearsBack;
  final ScrollController? scrollController;
  final AsyncValue<Movie> movie;
  final AsyncValue<List<Trailer>> movieVideos;
  final AsyncValue<List<Actor>> cast;
  final AsyncValue<List<Movie>> otherMovies;
  final AsyncValue<List<Movie>> actorMovies;

  MovieFlowState copyWith({
    ThemeMode? themeMode,
    PageController? pageController,
    AsyncValue<List<Genre>>? genres,
    int? rating,
    int? yearsBack,
    ScrollController? scrollController,
    AsyncValue<Movie>? movie,
    AsyncValue<List<Trailer>>? movieVideos,
    AsyncValue<List<Actor>>? cast,
    AsyncValue<List<Movie>>? otherMovies,
    AsyncValue<List<Movie>>? actorMovies,
  }) {
    return MovieFlowState(
      themeMode: themeMode ?? this.themeMode,
      pageController: pageController ?? this.pageController,
      genres: genres ?? this.genres,
      rating: rating ?? this.rating,
      yearsBack: yearsBack ?? this.yearsBack,
      scrollController: scrollController ?? this.scrollController,
      movie: movie ?? this.movie,
      movieVideos: movieVideos ?? this.movieVideos,
      cast: cast ?? this.cast,
      otherMovies: otherMovies ?? this.otherMovies,
      actorMovies: actorMovies ?? this.actorMovies,
    );
  }

  @override
  List<Object?> get props =>
      [
        themeMode,
        pageController,
        genres,
        rating,
        yearsBack,
        scrollController,
        movie,
        movieVideos,
        cast,
        otherMovies,
        actorMovies,
      ];
}
