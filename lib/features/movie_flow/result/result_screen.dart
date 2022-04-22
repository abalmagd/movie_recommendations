import 'package:flutter/material.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendations/features/movie_flow/result/movie.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({Key? key}) : super(key: key);

  static route({bool fullScreenDialog = false}) => MaterialPageRoute(
        builder: (context) => const ResultScreen(),
        fullscreenDialog: fullScreenDialog,
      );

  final Movie movie = const Movie(
    title: 'The Hulk',
    overview: 'Green man very strong bad experiment marvel disney',
    voteAverage: 5,
    genres: [
      Genre(name: 'Action'),
      Genre(name: 'Thrill'),
      Genre(name: 'Family'),
    ],
    releaseDate: '2020-4-22',
    backDropPath: '',
    posterPath: '',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomLeft,
                  children: const [
                    _CoverImage(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 300),
      child: ShaderMask(
        blendMode: BlendMode.dstIn,
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Colors.transparent,
            ],
          ).createShader(Rect.fromLTRB(0, 0, bounds.width, bounds.height));
        },
        child: const Placeholder(),
      ),
    );
  }
}
