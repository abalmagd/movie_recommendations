import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendations/features/movie_flow/movie_repository.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie.dart';

abstract class MovieService {
  Future<List<Genre>> getGenres();

  Future<Movie> getRecommendedMovie(
      int rating, List<Genre> genres, int yearsBack,
      [DateTime? yearsBackFromDate]);
}

final movieServiceProvider = Provider<MovieService>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider);
  return TMDBMovieService(movieRepository);
});

class TMDBMovieService implements MovieService {
  TMDBMovieService(this._movieRepository);

  final MovieRepository _movieRepository;
  late final List<Genre> genres;

  @override
  Future<List<Genre>> getGenres() async {
    final genreEntities = await _movieRepository.getMovieGenres();
    genres = genreEntities.map((e) => Genre.fromEntity(e)).toList();

    return genres;
  }

  @override
  Future<Movie> getRecommendedMovie(
      int rating, List<Genre> genres, int yearsBack,
      [DateTime? yearsBackFromDate]) async {
    final date = yearsBackFromDate ?? DateTime.now();
    final year = date.year - yearsBack;
    final genreIds = genres.map((e) => e.id).toList().join(',');

    final movieEntities = await _movieRepository.getRecommendedMovies(
      rating.toDouble(),
      '$year-01-01',
      genreIds,
    );

    final movies = movieEntities
        .map(
          (e) => Movie.fromEntity(
            e,
            this
                .genres
                .where((element) => e.genreIds.contains(element.id))
                .toList(),
          ),
        )
        .toList();

    final rnd = Random();
    final randomMovie = movies[rnd.nextInt(movies.length)];

    return randomMovie;
  }
}