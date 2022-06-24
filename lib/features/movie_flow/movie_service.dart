import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/failure.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendations/features/movie_flow/movie_repository.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie.dart';
import 'package:movie_recommendations/features/movie_flow/result/person_result/actor.dart';
import 'package:movie_recommendations/features/movie_flow/result/trailer.dart';

abstract class MovieService {
  Future<Either<Failure, List<Genre>>> getGenres();

  Future<Either<Failure, Movie>> getMovie(
      int rating, List<Genre> genres, int yearsBack,
      [DateTime? yearsBackFromDate]);

  Future<Either<Failure, List<Movie>>> getRecommendedMovies(int movieId);

  Future<Either<Failure, List<Actor>>> getMovieCast(int movieId);

  Future<Either<Failure, List<Movie>>> getActorMovies(int personId);

  Future<Either<Failure, List<Trailer>>> getMovieTrailers(int movieId);
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
  Future<Either<Failure, List<Genre>>> getGenres() async {
    try {
      final genreEntities = await _movieRepository.getMovieGenres();
      genres = genreEntities.map((e) => Genre.fromEntity(e)).toList();

      return Right(genres);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovie(
      int rating, List<Genre> genres, int yearsBack,
      [DateTime? yearsBackFromDate]) async {
    try {
      final date = yearsBackFromDate ?? DateTime.now();
      final year = date.year - yearsBack;
      final genreIds = genres.map((e) => e.id).toList().join(',');

      final movieEntities = await _movieRepository.getMovie(
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
                  .where(
                    (element) => e.genreIds.contains(element.id),
                  )
                  .toList(),
            ),
          )
          .toList();

      final rnd = Random();
      final randomMovie = movies[rnd.nextInt(movies.length)];

      return Right(randomMovie);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getRecommendedMovies(int movieId) async {
    try {
      final similarMovieEntities =
          await _movieRepository.getRecommendedMovies(movieId);

      final similarMovies = similarMovieEntities
          .map(
            (e) => Movie.fromEntity(
              e,
              genres
                  .where((element) => e.genreIds.contains(element.id))
                  .toList(),
            ),
          )
          .toList();

      return Right(similarMovies);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<Actor>>> getMovieCast(int movieId) async {
    try {
      return Right(await _movieRepository.getMovieCast(movieId));
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getActorMovies(int personId) async {
    try {
      final actorMovieEntities =
          await _movieRepository.getActorMovies(personId);

      final actorMovies = actorMovieEntities
          .map(
            (e) => Movie.fromEntity(
              e,
              genres
                  .where((element) => e.genreIds.contains(element.id))
                  .toList(),
            ),
          )
          .toList();

      return Right(actorMovies);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, List<Trailer>>> getMovieTrailers(int movieId) async {
    try {
      final videos = await _movieRepository.getMovieTrailers(movieId);
      final trailers = videos.where((e) => (e.official)).toList();

      return Right(trailers);
    } on Failure catch (failure) {
      return Left(failure);
    }
  }
}
