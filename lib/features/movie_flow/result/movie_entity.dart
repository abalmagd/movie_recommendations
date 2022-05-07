import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class MovieEntity extends Equatable {
  const MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.voteAverage,
    required this.genreIds,
    required this.releaseDate,
    this.posterPath,
    this.backDropPath,
  });

  factory MovieEntity.fromMap(Map<String, dynamic> map) {
    return MovieEntity(
      id: map['id'],
      title: map['title'],
      overview: map['overview'],
      genreIds: List.from(map['genre_ids']),
      voteAverage: map['vote_average'],
      releaseDate: map['release_date'] ?? 'Unknown',
      posterPath: map['poster_path'],
      backDropPath: map['backdrop_path'],
    );
  }

  final int id;
  final String title;
  final String overview;
  final num voteAverage;
  final List<int> genreIds;
  final String releaseDate;
  final String? posterPath;
  final String? backDropPath;

  @override
  String toString() =>
      'MovieEntity(id: $id, title: $title, overview: $overview, '
      'voteAverage: $voteAverage, genres: ${genreIds.toString()}, '
      'releaseDate: $releaseDate, posterPath: $posterPath, '
      'backDropPath: $backDropPath)';

  @override
  List<Object?> get props =>
      [
        id,
        title,
        overview,
        voteAverage,
        genreIds,
        releaseDate,
        posterPath,
        backDropPath,
      ];
}
