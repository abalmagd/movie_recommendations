import 'package:flutter/material.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/core/widgets/button.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre.dart';
import 'package:movie_recommendations/features/movie_flow/genre/list_card.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({
    Key? key,
    required this.nextPage,
    required this.previousPage,
  }) : super(key: key);

  final VoidCallback nextPage;
  final VoidCallback previousPage;

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  List<Genre> genres = const [
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

  void toggleSelected(Genre genre) {
    List<Genre> updatedGenres = [
      for (final oldGenre in genres)
        if (oldGenre == genre) oldGenre.toggleSelected() else oldGenre
    ];
    setState(() {
      genres = updatedGenres;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: widget.previousPage,
        ),
      ),
      body: Column(
        children: [
          Text(
             'Choose a genre!',
            style: theme.textTheme.headline5,
            textAlign: TextAlign.center,
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: kMediumSpacing),
              itemBuilder: (context, index) {
                final genre = genres[index];
                return ListCard(
                  genre: genre,
                  onTap: () => toggleSelected(genre),
                );
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(height: kMediumSpacing),
              itemCount: genres.length,
            ),
          ),
          Button(
            onPressed: widget.nextPage,
            text: 'Continue',
          ),
          const SizedBox(height: kMediumSpacing),
        ],
      ),
    );
  }
}
