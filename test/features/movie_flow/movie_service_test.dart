import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_recommendations/core/failure.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre_entity.dart';
import 'package:movie_recommendations/features/movie_flow/movie_repository.dart';
import 'package:movie_recommendations/features/movie_flow/movie_service.dart';

class TMDBMovieRepositoryMock extends Mock implements MovieRepository {}

void main() {
  late TMDBMovieRepositoryMock mockedMovieRepository;
  List<GenreEntity> genreEntities = [
    const GenreEntity(id: 1, name: 'Action'),
    const GenreEntity(id: 2, name: 'Drama'),
    const GenreEntity(id: 3, name: 'Comedy'),
    const GenreEntity(id: 4, name: 'Crime'),
  ];

  List<Genre> genres = [
    const Genre(id: 1, name: 'Action'),
    const Genre(id: 2, name: 'Drama'),
    const Genre(id: 3, name: 'Comedy'),
    const Genre(id: 4, name: 'Crime'),
  ];

  setUp(() {
    mockedMovieRepository = TMDBMovieRepositoryMock();
  });

  test(
    'Given successful call When getting GenreEntities Then map to correct genres',
    () async {
      when(() => mockedMovieRepository.getMovieGenres()).thenAnswer(
        (invocation) => Future.value(genreEntities),
      );

      final movieService = TMDBMovieService(mockedMovieRepository);

      final result = await movieService.getGenres();

      result.fold(
        (l) => expect(l, genres),
        (r) => expect(r, genres),
      );
    },
  );

  test(
    'Given failed call When getting GenreEntities Then return Failure',
    () async {
      when(() => mockedMovieRepository.getMovieGenres()).thenThrow(
        Failure(
          message: 'No internet',
          exception: const SocketException(''),
        ),
      );

      final movieService = TMDBMovieService(mockedMovieRepository);

      final result = await movieService.getGenres();

      result.fold(
        (l) => expect(l.exception, isA<SocketException>()),
        (r) => expect(r, genres),
      );
    },
  );
}
