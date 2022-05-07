import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Actor extends Equatable {
  const Actor({
    required this.id,
    required this.name,
    required this.character,
    required this.order,
    this.profilePath,
  });

  const Actor.initial()
      : id = 0,
        name = '',
        character = '',
        order = 0,
        profilePath = '';

  factory Actor.fromMap(Map<String, dynamic> map) {
    return Actor(
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
      'order: $order, profilePath: $profilePath)';

  @override
  List<Object?> get props => [id, name, character, order, profilePath];
}
