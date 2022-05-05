import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie_entity.dart';

@immutable
class Movie extends Equatable {
  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.genres,
    required this.releaseDate,
    this.backDropPath,
    this.posterPath,
  });

  Movie.initial()
      : id = 0,
        title = '',
        overview = '',
        voteAverage = '0',
        genres = [],
        releaseDate = '',
        backDropPath = '',
        posterPath = '';

  factory Movie.fromEntity(MovieEntity entity, List<Genre> genres) {
    return Movie(
      id: entity.id,
      title: entity.title,
      overview: entity.overview,
      voteAverage: entity.voteAverage.toStringAsFixed(1).endsWith('0')
          ? entity.voteAverage.toStringAsFixed(0)
          : entity.voteAverage.toStringAsFixed(1),
      genres: genres,
      releaseDate: entity.releaseDate.substring(0, 4),
      posterPath: 'https://image.tmdb.org/t/p/w500/${entity.posterPath}',
      backDropPath:
          'https://image.tmdb.org/t/p/original/${entity.backDropPath}',
    );
  }

  final String title;
  final int id;
  final String overview;
  final String voteAverage;
  final List<Genre> genres;
  final String releaseDate;
  final String? backDropPath;
  final String? posterPath;

  String get genresCommaSeparated =>
      genres.map((genre) => genre.name).toList().join(', ');

  @override
  String toString() => 'Movie(id: $id, title: $title, overview: $overview, '
      'voteAverage: $voteAverage, genres: {$genresCommaSeparated}, '
      'releaseDate: $releaseDate, backDropPath: $backDropPath, '
      'posterPath: $posterPath,)';

  @override
  List<Object?> get props => [
        id,
        title,
        overview,
        voteAverage,
        genres,
        releaseDate,
        posterPath,
        backDropPath,
      ];
}
