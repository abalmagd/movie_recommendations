import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Genre extends Equatable {
  const Genre({
    required this.name,
    this.id = 0,
    this.isSelected = false,
  });

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
