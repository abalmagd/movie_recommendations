import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre.dart';

@immutable
class Movie extends Equatable {
  const Movie({
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.genres,
    required this.releaseDate,
    this.backDropPath,
    this.posterPath,
  });

  Movie.initial()
      : title = '',
        overview = '',
        voteAverage = 0,
        genres = [],
        releaseDate = '',
        backDropPath = '',
        posterPath = '';

  final String title;
  final String overview;
  final num voteAverage;
  final List<Genre> genres;
  final String releaseDate;
  final String? backDropPath;
  final String? posterPath;

  String get genresCommaSeparated =>
      genres.map((genre) => genre.name).toList().join(', ');

  @override
  String toString() =>
      'Movie(title: $title, overview: $overview, voteAverage: $voteAverage, '
      'genres: {$genresCommaSeparated}, releaseDate: $releaseDate, '
      'backDropPath: $backDropPath, posterPath: $posterPath)';

  @override
  List<Object?> get props => [title, overview];
}
