import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class MovieEntity extends Equatable {
  const MovieEntity({
    required this.title,
    required this.overview,
    required this.releaseDate,
    required this.genreIds,
    required this.voteAverage,
    required this.totalResults,
    required this.totalPages,
    this.posterPath,
    this.backDropPath,
  });

  factory MovieEntity.fromMap(Map<String, dynamic> map) {
    return MovieEntity(
      title: map['title'],
      overview: map['overview'],
      genreIds: List.from(map['genre_ids']),
      voteAverage: map['vote_average'],
      totalResults: map['total_results'],
      totalPages: map['total_pages'],
      releaseDate: map['release_date'],
    );
  }

  final String title;
  final String overview;
  final List<int> genreIds;
  final String releaseDate;
  final num voteAverage;
  final int totalResults;
  final int totalPages;
  final String? posterPath;
  final String? backDropPath;

  @override
  String toString() => 'MovieEntity(title: $title, overview: $overview, '
      'releaseDate: $releaseDate, genres: ${genreIds.toString()}, '
      'voteAverage: $voteAverage, totalResults: $totalResults, '
      'totalPages: $totalPages)';

  @override
  List<Object?> get props => [
        title,
        overview,
        genreIds,
        voteAverage,
        posterPath,
        backDropPath,
        // Todo: Implement pagination after core app is finished
        // totalResults,
        // totalPages,
      ];
}
