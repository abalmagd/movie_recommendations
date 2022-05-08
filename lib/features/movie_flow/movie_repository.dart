import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_recommendations/core/environment_variables.dart';
import 'package:movie_recommendations/core/network/dio.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre_entity.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie_entity.dart';
import 'package:movie_recommendations/features/movie_flow/result/person_result/actor.dart';

abstract class MovieRepository {
  Future<List<GenreEntity>> getMovieGenres();

  Future<List<MovieEntity>> getMovie(
    double rating,
    String date,
    String genreIds,
  );

  Future<List<MovieEntity>> getRecommendedMovies(int movieId);

  Future<List<Actor>> getMovieCast(int movieId);

  Future<List<MovieEntity>> getActorMovies(int personId);
}

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return TMDBMovieRepository(dio: ref.watch(dioProvider));
});

class TMDBMovieRepository implements MovieRepository {
  TMDBMovieRepository({required this.dio});

  final Dio dio;

  @override
  Future<List<GenreEntity>> getMovieGenres() async {
    final response = await dio.get(
      genresEndpoint,
      queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
      },
    );

    final results = List<Map<String, dynamic>>.from(response.data['genres']);

    debugPrint('Request to get genres => '
        'Status: ${response.statusCode}, '
        'Message: ${response.statusMessage}, '
        'Genres: ${results.toString()}');

    final genres = results.map((e) => GenreEntity.fromMap(e)).toList();

    return genres;
  }

  @override
  Future<List<MovieEntity>> getMovie(
    double rating,
    String date,
    String genreIds,
  ) async {
    final response = await dio.get(
      discoverMoviesEndpoint,
      queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
        'sort_by': 'popularity.desc',
        'include_adult': false,
        'release_date.gte': date,
        'vote_count.gte': rating,
        'with_genres': genreIds,
      },
    );

    final result = List<Map<String, dynamic>>.from(response.data['results']);

    debugPrint('Request to get Movies => '
        'Status: ${response.statusCode}, '
        'Message: ${response.statusMessage}, '
        'Movies: ${result.length},'
        '# Pages: ${response.data['total_pages']},'
        '# Results: ${response.data['total_results']},');

    final movieEntities = result.map((e) => MovieEntity.fromMap(e)).toList();

    return movieEntities;
  }

  @override
  Future<List<MovieEntity>> getRecommendedMovies(int movieId) async {
    final String recommendedMoviesEndpoint = '/movie/$movieId/recommendations';
    final response = await dio.get(
      recommendedMoviesEndpoint,
      queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
      },
    );

    final results = List<Map<String, dynamic>>.from(response.data['results']);

    final movieEntities = results.map((e) => MovieEntity.fromMap(e)).toList();

    return movieEntities;
  }

  @override
  Future<List<Actor>> getMovieCast(int movieId) async {
    final String creditsEndpoint = '/movie/$movieId/credits';
    final response = await dio.get(
      creditsEndpoint,
      queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
      },
    );

    final results = List<Map<String, dynamic>>.from(response.data['cast']);
    final cast = results.map((e) => Actor.fromMap(e)).toList();

    return cast;
  }

  @override
  Future<List<MovieEntity>> getActorMovies(int personId) async {
    final String actorMoviesEndpoint = '/person/$personId/movie_credits';

    final response = await dio.get(
      actorMoviesEndpoint,
      queryParameters: {
        'api_key': apiKey,
        'language': 'en-US',
      },
    );

    final result = List<Map<String, dynamic>>.from(response.data['cast']);

    final actorMovies = result.map((e) => MovieEntity.fromMap(e)).toList();

    return actorMovies;
  }
}
