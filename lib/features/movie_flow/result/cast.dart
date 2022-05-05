import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Cast extends Equatable {
  const Cast({
    required this.id,
    required this.name,
    required this.character,
    required this.order,
    this.profilePath,
  });

  const Cast.initial()
      : id = 0,
        name = '',
        character = '',
        order = 0,
        profilePath = '';

  factory Cast.fromMap(Map<String, dynamic> map) {
    return Cast(
      id: map['id'],
      name: map['name'],
      character: map['character'],
      order: map['order'],
      profilePath: 'https://image.tmdb.org/t/p/w500/${map['profile_path']}',
    );
  }

  final int id;
  final String name;
  final String character;
  final int order;
  final String? profilePath;

  @override
  String toString() => 'Cast(id: $id, name: $name, character: $character, '
      'order: $order, profilePath: $profilePath,)';

  @override
  List<Object?> get props => [id, name, character, order, profilePath];
}
