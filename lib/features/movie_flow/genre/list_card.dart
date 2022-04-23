import 'package:flutter/material.dart';
import 'package:movie_recommendations/core/constants.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre.dart';

class ListCard extends StatelessWidget {
  const ListCard({
    Key? key,
    required this.genre,
    required this.onTap,
  }) : super(key: key);

  final Genre genre;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Material(
        color: genre.isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(kSmallSpacing),
        child: InkWell(
          borderRadius: BorderRadius.circular(kSmallSpacing),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: kMediumSpacing,
              vertical: kSmallSpacing,
            ),
            width: 140,
            child: Text(
              genre.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    color: genre.isSelected
                        ? Colors.white
                        : Theme.of(context).textTheme.bodyText2?.color,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
