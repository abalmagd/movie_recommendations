import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:movie_recommendations/features/movie_flow/genre/genre_entity.dart';

@immutable
class Genre extends Equatable {
  const Genre({
    required this.name,
    this.id = 0,
    this.isSelected = false,
  });

  factory Genre.fromEntity(GenreEntity entity) {
    return Genre(
      name: entity.name,
      id: entity.id,
      isSelected: false,
    );
  }

  final int id;
  final String name;
  final bool isSelected;

  Genre toggleSelected() {
    return Genre(
      name: name,
      id: id,
      isSelected: !isSelected,
    );
  }

  @override
  String toString() => 'Genre(id: $id, name: $name, isSelected: $isSelected)';

  @override
  List<Object?> get props => [id, name, isSelected];
}
