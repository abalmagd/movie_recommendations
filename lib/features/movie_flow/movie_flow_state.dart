import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie.dart';

const Movie movieMock = Movie(
  title: 'The Hulk',
  overview:
      'Scientist Bruce Banner (Edward Norton) desperately seeks a cure for '
      'the gamma radiation that contaminated his cells and turned him '
      'into The Hulk. Cut off from his true love Betty Ross (Liv Tyler) '
      'and forced to hide from his nemesis, Gen. Thunderbolt Ross '
      '(William Hurt), Banner soon comes face-to-face with a new threat: '
      'a supremely powerful enemy known as The Abomination (Tim Roth).',
  voteAverage: 5,
  genres: [
    Genre(name: 'Action'),
    Genre(name: 'Thrill'),
    Genre(name: 'Fantasy'),
  ],
  releaseDate: '2020-4-22',
  backDropPath: '',
  posterPath: '',
);

const List<Genre> genresMock = [
  Genre(name: 'Comedy'),
  Genre(name: 'Horror'),
  Genre(name: 'Sci-Fi'),
  Genre(name: 'Fantasy'),
  Genre(name: 'Anime'),
  Genre(name: 'Drama'),
  Genre(name: 'Family'),
  Genre(name: 'Action'),
  Genre(name: 'Romance'),
];

@immutable
class MovieFlowState extends Equatable {
  const MovieFlowState({
    required this.pageController,
    this.rating = 5,
    this.yearsBack = 10,
    this.genres = genresMock,
    this.movie = movieMock,
  });

  final PageController pageController;
  final int rating;
  final int yearsBack;
  final List<Genre> genres;
  final Movie movie;

  MovieFlowState copyWith({
    PageController? pageController,
    int? rating,
    int? yearsBack,
    List<Genre>? genres,
    Movie? movie,
  }) {
    return MovieFlowState(
      pageController: pageController ?? this.pageController,
      rating: rating ?? this.rating,
      yearsBack: yearsBack ?? this.yearsBack,
      genres: genres ?? this.genres,
      movie: movie ?? this.movie,
    );
  }

  @override
  List<Object?> get props => [pageController, rating, yearsBack, genres, movie];
}
